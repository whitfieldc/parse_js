require 'rkelly/js/base'
require 'rkelly/js/nan'
require 'rkelly/js/function'
require 'rkelly/js/error'
require 'rkelly/runtime/completion'
require 'rkelly/runtime/reference'

module RKelly
  module Visitors
    class EvaluationVisitor < Visitor

      # Shorthand for the completion object creator
      COMPLETION = Runtime::Completion

      # One shared NaN object
      NAN = JS::NaN.new

      def initialize(environment)
        super()
        @environment = environment
        @labels = []
      end

      ## 11 Expressions

      ## 11.1 Primary Expressions

      ## 11.1.1 The 'this' Reference
      def visit_ThisNode(o)
        @environment.this
      end

      ## 11.1.2 Identifier Reference
      def visit_ResolveNode(o)
        @environment[o.value]
      end

      ## 11.1.3 Literal Reference
      def visit_NullNode(o)
        nil
      end

      def visit_TrueNode(o)
        true
      end

      def visit_FalseNode(o)
        false
      end

      def visit_StringNode(o)
        o.value.gsub(/\A['"]/, '').gsub(/['"]$/, '')
      end

      def visit_NumberNode(o)
        o.value
      end

      ## 11.1.5 Object Initialiser

      def visit_ObjectLiteralNode(o)
        obj = @environment["Object"].construct()
        o.value.each do |prop|
          obj[prop.name] = prop.value.accept(self)
        end
        obj
      end

      ## 11.2 Left-Hand-Side Expressions

      ## 11.2.1 Property Accessors
      def visit_DotAccessorNode(o)
        obj = o.value.accept(self)
        obj[o.accessor]
      end

      def visit_BracketAccessorNode(o)
        obj = o.value.accept(self)
        obj[o.accessor.accept(self)]
      end

      ## 11.2.2 The 'new' Operator
      def visit_NewExprNode(o)
        fn = o.value.accept(self)
        args = o.arguments.accept(self)
        fn.construct(*args)
      end

      ## 11.2.3 Function Calls
      def visit_FunctionCallNode(o)
        ref = make_reference(o.value)
        args = o.arguments.accept(self)

        if ref.bound_to_object?
          # When obj.fun() syntax used
          call_function(ref.value, ref.binder, args)
        else
          # When fun() syntax used
          call_function(ref.value, nil, args)
        end
      end

      ## 11.2.4 Argument Lists
      def visit_ArgumentsNode(o)
        o.value.map { |x| x.accept(self) }
      end

      ## 11.3 Postfix Expressions

      def visit_PostfixNode(o)
        ref = make_reference(o.operand)
        number = to_number(ref.value)
        case o.value
        when '++'
          ref.value = number + 1
        when '--'
          ref.value = number - 1
        end
        number
      end

      ## 11.4 Unary Operators

      ## 11.4.1 The 'delete' Operator
      def visit_DeleteNode(o)
        ref = make_reference(o.value)
        ref.delete!
      end

      ## 11.4.2 The 'void' Operator
      def visit_VoidNode(o)
        o.value.accept(self)
        :undefined
      end

      ## 11.4.3 The 'typeof' Operator
      def visit_TypeOfNode(o)
        val = o.value.accept(self)
        return 'object' if val.nil?
        return 'function' if val.respond_to?(:call)

        case val
        when String
          'string'
        when Numeric
          'number'
        when true
          'boolean'
        when false
          'boolean'
        when :undefined
          'undefined'
        else
          'object'
        end
      end

      ## 11.4.4 Prefix Increment Operator
      ## 11.4.5 Prefix Decrement Operator
      def visit_PrefixNode(o)
        ref = make_reference(o.operand)
        number = to_number(ref.value)
        case o.value
        when '++'
          ref.value = number + 1
        when '--'
          ref.value = number - 1
        end
        ref.value
      end

      ## 11.4.6 Unary + Operator
      def visit_UnaryPlusNode(o)
        orig = o.value.accept(self)
        to_number(orig)
      end

      ## 11.4.7 Unary - Operator
      def visit_UnaryMinusNode(o)
        orig = o.value.accept(self)
        v = to_number(orig)
        (v == 0) ? -0.0 : 0 - v
      end

      ## 11.4.8 Binary NOT Operator (~)
      def visit_BitwiseNotNode(o)
        orig = o.value.accept(self)
        ~to_int_32(orig)
      end

      ## 11.4.9 Logical NOT Operator (!)
      def visit_LogicalNotNode(o)
        !to_boolean(o.value.accept(self))
      end

      ## 11.5 Multiplicative Operators

      def visit_MultiplyNode(o)
        left = to_number(o.left.accept(self))
        right = to_number(o.value.accept(self))

        if nan?(left) || nan?(right)
          NAN
        else
          if (infinite?(left) || infinite?(right)) && (left == 0 || right == 0)
            NAN
          else
            left * right
          end
        end
      end

      def visit_DivideNode(o)
        left = to_number(o.left.accept(self))
        right = to_number(o.value.accept(self))

        if nan?(left) || nan?(right)
          NAN
        elsif infinite?(left) && infinite?(right)
          NAN
        elsif left == 0 && right == 0
          NAN
        elsif right == 0
          left * (right.eql?(0) ? (1.0/0.0) : (-1.0/0.0))
        else
          left / right
        end
      end

      def visit_ModulusNode(o)
        left = to_number(o.left.accept(self))
        right = to_number(o.value.accept(self))

        if nan?(left) || nan?(right)
          NAN
        elsif infinite?(left) && infinite?(right)
          NAN
        elsif right == 0
          NAN
        elsif infinite?(left)
          NAN
        elsif infinite?(right)
          left
        else
          left % right
        end
      end

      ## 11.6 Additive Operators

      def visit_AddNode(o)
        left  = to_primitive(o.left.accept(self), 'Number')
        right = to_primitive(o.value.accept(self), 'Number')

        if left.is_a?(::String) || right.is_a?(::String)
          "#{left}#{right}"
        else
          additive_operator(:+, left, right)
        end
      end

      def visit_SubtractNode(o)
        o.left.accept(self) - o.value.accept(self)
      end

      ## 11.8 Relational Operators

      def visit_LessNode(o)
        relational_comparison(o) {|x, y| x < y }
      end

      def visit_GreaterNode(o)
        relational_comparison(o) {|x, y| x > y }
      end

      def visit_LessOrEqualNode(o)
        relational_comparison(o) {|x, y| x <= y }
      end

      def visit_GreaterOrEqualNode(o)
        relational_comparison(o) {|x, y| x >= y }
      end

      def visit_InNode(o)
        key = o.left.accept(self)
        obj = o.value.accept(self)
        if object?(obj)
          obj.has_property?(key)
        else
          raise JS::TypeError
        end
      end

      ## 11.9 Equality Operators

      def visit_EqualNode(o)
        left = o.left.accept(self)
        right = o.value.accept(self)

        left == right
      end

      ## 11.13 Assignment Operators

      def visit_OpEqualNode(o)
        ref = make_reference(o.left)
        ref.value = o.value.accept(self)
      end

      [
        ["OpPlusEqualNode", :+],
        ["OpMinusEqualNode", :-],
        ["OpMultiplyEqualNode", :*],
        ["OpDivideEqualNode", :/],
        ["OpModEqualNode", :%],
        ["OpAndEqualNode", :&],
        ["OpOrEqualNode", :|],
        ["OpXOrEqualNode", :^],
        ["OpLShiftEqualNode", :<<],
        ["OpRShiftEqualNode", :>>],
      ].each do |name, operator|
        define_method(:"visit_#{name}") do |o|
          ref = make_reference(o.left)
          ref.value = ref.value.send(operator, o.value.accept(self))
        end
      end


      ## 12 Statements

      ## 12.1 Block
      def visit_BlockNode(o)
        o.value.accept(self)
      end

      def visit_SourceElementsNode(o)
        final_value = nil

        o.value.each do |statement|
          c = statement.accept(self)
          return c if c.abrupt?

          # remember the value of a last statement with a value.
          final_value = c.value if c.value
        end

        COMPLETION[:normal, final_value]
      end

      ## 12.2 Variable Statement
      def visit_VarStatementNode(o)
        o.value.each { |x| x.accept(self) }
        COMPLETION[:normal]
      end

      def visit_VarDeclNode(o)
        return unless o.value
        # Handling also the AssignExprNode
        @environment[o.name] = o.value.value.accept(self)
      end

      ## 12.3 Empty Statement
      def visit_EmptyStatementNode(o)
        # do nothing
        COMPLETION[:normal]
      end

      ## 12.4 Expression Statement
      def visit_ExpressionStatementNode(o)
        COMPLETION[:normal, o.value.accept(self)]
      end

      ## 12.5 If Statement
      def visit_IfNode(o)
        if to_boolean(o.conditions.accept(self))
          o.value.accept(self)
        elsif o.else
          o.else.accept(self)
        else
          COMPLETION[:normal]
        end
      end

      ## 12.6 Iteration Statements
      def visit_DoWhileNode(o)
        final_value = nil

        begin
          c = o.left.accept(self)

          final_value = c.value if c.value

          if complete?(c, :continue, o)
            # do nothing
          elsif complete?(c, :break, o)
            return COMPLETION[:normal, final_value]
          elsif c.abrupt?
            return c
          end
        end while to_boolean(o.value.accept(self))

        COMPLETION[:normal, final_value]
      end

      def visit_WhileNode(o)
        final_value = nil

        while to_boolean(o.left.accept(self))
          c = o.value.accept(self)

          final_value = c.value if c.value

          if complete?(c, :continue, o)
            # do nothing
          elsif complete?(c, :break, o)
            return COMPLETION[:normal, final_value]
          elsif c.abrupt?
            return c
          end
        end

        COMPLETION[:normal, final_value]
      end

      def visit_ForNode(o)
        final_value = nil
        o.init.accept(self) if o.init

        while (!o.test || to_boolean(o.test.accept(self)))
          c = o.value.accept(self)

          final_value = c.value if c.value

          if complete?(c, :continue, o)
            # do nothing
          elsif complete?(c, :break, o)
            return COMPLETION[:normal, final_value]
          elsif c.abrupt?
            return c
          end

          o.counter.accept(self) if o.counter
        end

        COMPLETION[:normal, final_value]
      end

      def visit_ForInNode(o)
        final_value = nil

        ref = make_reference(o.left)

        obj = o.right.accept(self)
        if obj == nil || obj == :undefined
          return COMPLETION[:normal]
        end
        # TODO: Call builtin toObject(obj)

        obj.enumerable_keys.each do |key|
          next unless obj.has_property?(key)
          ref.value = key

          c = o.value.accept(self)

          final_value = c.value if c.value

          if c.type == :continue
            # do nothing
          elsif c.type == :break
            return COMPLETION[:normal, final_value]
          elsif c.abrupt?
            return c
          end
        end

        COMPLETION[:normal, final_value]
      end

      ## 12.8 The 'continue' Statement
      def visit_ContinueNode(o)
        COMPLETION[:continue, nil, o.value]
      end

      ## 12.8 The 'break' Statement
      def visit_BreakNode(o)
        COMPLETION[:break, nil, o.value]
      end

      ## 12.9 The 'return' Statement
      def visit_ReturnNode(o)
        COMPLETION[:return, o.value ? o.value.accept(self) : :undefined]
      end

      ## 12.10 The 'with' Statement
      def visit_WithNode(o)
        obj = o.left.accept(self)
        # TODO: Call builtin toObject(obj)

        @environment = @environment.new_object(obj)

        c = o.value.accept(self)

        @environment = @environment.outer

        c
      end

      ## 12.11 The 'switch' Statement
      def visit_SwitchNode(o)
        final_value = nil
        searching = true

        exp = o.left.accept(self)

        # SwitchNode -> CaseBlockNode -> [CaseClauseNode]
        o.value.value.each do |clause|
          if !searching || clause.left.nil? || clause.left.accept(self) == exp
            searching = false
            c = clause.value.accept(self)
            if c.abrupt?
              return c
            else
              final_value = c.value
            end
          end
        end

        COMPLETION[:normal, final_value]
      end

      ## 12.12 Labelled Statements
      def visit_LabelNode(o)
        with_label(o) do
          o.value.accept(self)
        end
      end


      ## 13 Function Definition

      def visit_FunctionDeclNode(o)
        COMPLETION[:normal]
      end

      def visit_FunctionExprNode(o)
        JS::Function.new(@environment, o.function_body, o.arguments)
      end

      def visit_FunctionBodyNode(o)
        c = o.value.accept(self)
        if c.type == :return && c.value
          c.value
        else
          :undefined
        end
      end

      %w{
        ArrayNode BitAndNode BitOrNode
        BitXOrNode
        CommaNode ConditionalNode
        ConstStatementNode
        ElementNode
        GetterPropertyNode
        InstanceOfNode LeftShiftNode
        LogicalAndNode LogicalOrNode
        NotEqualNode NotStrictEqualNode
        OpURShiftEqualNode
        ParameterNode
        RegexpNode RightShiftNode
        SetterPropertyNode StrictEqualNode
        ThrowNode TryNode
        UnsignedRightShiftNode
      }.each do |type|
        define_method(:"visit_#{type}") do |o|
          raise "#{type} not defined"
        end
      end

      private

      def to_number(value)
        return 0 unless value

        case value
        when :undefined
          NAN
        when false
          0
        when true
          1
        when Numeric
          value
        when ::String
          s = value.gsub(/(\A[\s\xA0]*|[\s\xA0]*\Z)/n, '')
          if s.length == 0
            0
          else
            case s
            when /^([+-])?Infinity/
              $1 == '-' ? -1.0/0.0 : 1.0/0.0
            when /\A[-+]?\d+\.\d*(?:[eE][-+]?\d+)?$|\A[-+]?\d+(?:\.\d*)?[eE][-+]?\d+$|\A[-+]?\.\d+(?:[eE][-+]?\d+)?$/, /\A[-+]?0[xX][\da-fA-F]+$|\A[+-]?0[0-7]*$|\A[+-]?\d+$/
              s.gsub!(/\.(\D)/, '.0\1') if s =~ /\.\w/
              s.gsub!(/\.$/, '.0') if s =~ /\.$/
              s.gsub!(/^\./, '0.') if s =~ /^\./
              s.gsub!(/^([+-])\./, '\10.') if s =~ /^[+-]\./
              s = s.gsub(/^[0]*/, '') if /^0[1-9]+$/.match(s)
              eval(s)
            else
              NAN
            end
          end
        when JS::Base
          return to_number(to_primitive(value, 'Number'))
        end
      end

      def to_boolean(value)
        return false unless value

        case value
        when :undefined
          false
        when true
          true
        when Numeric
          value == 0 || nan?(value) ? false : true
        when ::String
          value.length == 0 ? false : true
        when JS::Base
          true
        else
          raise
        end
      end

      def to_int_32(object)
        value = to_number(object)
        return 0 if value == 0 || nan?(value) || infinite?(value)

        value = ((value < 0 ? -1 : 1) * value.abs.floor) % (2 ** 32)

        if value >= 2 ** 31
          value - (2 ** 32)
        else
          value
        end
      end

      def to_primitive(value, preferred_type = nil)
        return value unless value

        case value
        when false, true, :undefined, ::String, Numeric
          value
        when JS::Base
          call_function(value.default_value(preferred_type))
        end
      end

      def additive_operator(operator, left, right)
        left, right = to_number(left), to_number(right)

        left = nan?(left) ? 0.0/0.0 : left
        right = nan?(right) ? 0.0/0.0 : right

        result = left.send(operator, right)
        result = nan?(result) ? NAN : result

        result
      end

      def call_function(function, this=nil, arguments = [])
        this = this || @environment.global_object
        function.call(this, *arguments)
      end

      # 11.8.5 The Abstract Relational Comparison Algorithm
      #
      # Simplified version of the ECMA algorithm, that drops
      # the LeftFirst flag and uses #yield instead.  It also
      # incorporates the evaluation of both subexpressions.
      def relational_comparison(o)
        left = to_primitive(o.left.accept(self), "Number")
        right = to_primitive(o.value.accept(self), "Number")

        if left.is_a?(::String) && right.is_a?(::String)
          yield(left, right)
        else
          left = to_number(left)
          right = to_number(right)

          if nan?(left) || nan?(right)
            false
          else
            yield(left, right)
          end
        end
      end

      # Wraps syntax node inside Reference object.
      def make_reference(node)
        Runtime::Reference.new(node, @environment, self)
      end

      # Helper to check if x is NaN.
      def nan?(x)
        x.respond_to?(:nan?) && x.nan?
      end

      # Helper to check if x is +/-infinity.
      def infinite?(x)
        x.respond_to?(:infinite?) && x.infinite?
      end

      # Helper to check if x is object
      def object?(x)
        x.is_a?(JS::Base)
      end

      # Label handling:

      # Used in visit_LabelNode to remember the current label.
      def with_label(label_node, &block)
        @labels << label_node
        v = yield
        @labels.pop
        return v
      end

      # Returns the name of the current label.
      def current_label_name
        @labels.last.name
      end

      # Returns the statement associated with current label.
      def current_label_statement
        @labels.last.value
      end

      # Helper to check if completion is of specific type and it has
      # no target, or its target matches with the label of current
      # statement.
      def complete?(completion, type, statement)
        completion.type == type && (!completion.target || label_matches?(completion.target, statement))
      end

      def label_matches?(name, statement)
        statement == current_label_statement && name == current_label_name
      end

    end
  end
end
