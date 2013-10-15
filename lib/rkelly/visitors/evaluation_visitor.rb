module RKelly
  module Visitors
    class EvaluationVisitor < Visitor
      attr_reader :scope_chain
      def initialize(scope)
        super()
        @scope_chain = scope
        @operand = []
      end

      def visit_SourceElementsNode(o)
        o.value.each { |x|
          next if scope_chain.returned?
          x.accept(self)
        }
      end

      ## 11 Expressions

      ## 11.1 Primary Expressions

      ## 11.1.1 The 'this' Reference
      def visit_ThisNode(o)
        scope_chain.this
      end

      ## 11.1.2 Identifier Reference
      def visit_ResolveNode(o)
        scope_chain[o.value]
      end

      ## 11.1.3 Literal Reference
      def visit_NullNode(o)
        RKelly::JS::Property.new(nil, nil)
      end

      def visit_TrueNode(o)
        RKelly::JS::Property.new(true, true)
      end

      def visit_FalseNode(o)
        RKelly::JS::Property.new(false, false)
      end

      def visit_StringNode(o)
        RKelly::JS::Property.new(:string,
          o.value.gsub(/\A['"]/, '').gsub(/['"]$/, '')
        )
      end

      def visit_NumberNode(o)
        RKelly::JS::Property.new(o.value, o.value)
      end

      ## 11.2 Left-Hand-Side Expressions

      ## 11.2.1 Property Accessors
      def visit_DotAccessorNode(o)
        left = o.value.accept(self)
        right = left.value[o.accessor]
        right.binder = left.value
        right
      end

      ## 11.2.2 The 'new' Operator
      def visit_NewExprNode(o)
        visit_FunctionCallNode(o)
      end

      ## 11.2.3 Function Calls
      def visit_FunctionCallNode(o)
        left      = o.value.accept(self)
        arguments = o.arguments.accept(self)
        call_function(left, arguments)
      end

      ## 11.2.4 Argument Lists
      def visit_ArgumentsNode(o)
        o.value.map { |x| x.accept(self) }
      end

      ## 11.3 Postfix Expressions

      def visit_PostfixNode(o)
        orig = o.operand.accept(self)
        number = to_number(orig)
        case o.value
        when '++'
          orig.value = number.value + 1
        when '--'
          orig.value = number.value - 1
        end
        number
      end

      ## 11.4 Unary Operators

      ## 11.4.2 The 'void' Operator
      def visit_VoidNode(o)
        o.value.accept(self)
        RKelly::JS::Property.new(:undefined, :undefined)
      end

      ## 11.4.3 The 'typeof' Operator
      def visit_TypeOfNode(o)
        val = o.value.accept(self)
        return RKelly::JS::Property.new(:string, 'object') if val.value.nil?

        case val.value
        when String
          RKelly::JS::Property.new(:string, 'string')
        when Numeric
          RKelly::JS::Property.new(:string, 'number')
        when true
          RKelly::JS::Property.new(:string, 'boolean')
        when false
          RKelly::JS::Property.new(:string, 'boolean')
        when :undefined
          RKelly::JS::Property.new(:string, 'undefined')
        else
          RKelly::JS::Property.new(:object, 'object')
        end
      end

      ## 11.4.4 Prefix Increment Operator
      ## 11.4.5 Prefix Decrement Operator
      def visit_PrefixNode(o)
        orig = o.operand.accept(self)
        number = to_number(orig)
        case o.value
        when '++'
          orig.value = number.value + 1
        when '--'
          orig.value = number.value - 1
        end
        orig
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
        v.value = v.value == 0 ? -0.0 : 0 - v.value
        v
      end

      ## 11.4.8 Binary NOT Operator (~)
      def visit_BitwiseNotNode(o)
        orig = o.value.accept(self)
        number = to_int_32(orig)
        RKelly::JS::Property.new(nil, ~number.value)
      end

      ## 11.4.9 Logical NOT Operator (!)
      def visit_LogicalNotNode(o)
        bool = to_boolean(o.value.accept(self))
        bool.value = !bool.value
        bool
      end

      ## 11.5 Multiplicative Operators

      def visit_MultiplyNode(o)
        left = to_number(o.left.accept(self)).value
        right = to_number(o.value.accept(self)).value
        return_val =
          if nan?(left) || nan?(right)
            RKelly::JS::NaN.new
          else
            if (infinite?(left) || infinite?(right)) && (left == 0 || right == 0)
              RKelly::JS::NaN.new
            else
              left * right
            end
          end
        RKelly::JS::Property.new(:multiple, return_val)
      end

      def visit_DivideNode(o)
        left = to_number(o.left.accept(self)).value
        right = to_number(o.value.accept(self)).value
        return_val =
          if nan?(left) || nan?(right)
            RKelly::JS::NaN.new
          elsif infinite?(left) && infinite?(right)
            RKelly::JS::NaN.new
          elsif left == 0 && right == 0
            RKelly::JS::NaN.new
          elsif right == 0
            left * (right.eql?(0) ? (1.0/0.0) : (-1.0/0.0))
          else
            left / right
          end
        RKelly::JS::Property.new(:divide, return_val)
      end

      def visit_ModulusNode(o)
        left = to_number(o.left.accept(self)).value
        right = to_number(o.value.accept(self)).value
        return_val =
          if nan?(left) || nan?(right)
            RKelly::JS::NaN.new
          elsif infinite?(left) && infinite?(right)
            RKelly::JS::NaN.new
          elsif right == 0
            RKelly::JS::NaN.new
          elsif infinite?(left)
            RKelly::JS::NaN.new
          elsif infinite?(right)
            left
          else
            left % right
          end
        RKelly::JS::Property.new(:divide, return_val)
      end

      ## 11.6 Additive Operators

      def visit_AddNode(o)
        left  = to_primitive(o.left.accept(self), 'Number')
        right = to_primitive(o.value.accept(self), 'Number')

        if left.value.is_a?(::String) || right.value.is_a?(::String)
          RKelly::JS::Property.new(:add,
            "#{left.value}#{right.value}"
          )
        else
          additive_operator(:+, left, right)
        end
      end

      def visit_SubtractNode(o)
        RKelly::JS::Property.new(:subtract,
          o.left.accept(self).value - o.value.accept(self).value
        )
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

      ## 11.9 Equality Operators

      def visit_EqualNode(o)
        left = o.left.accept(self)
        right = o.value.accept(self)

        RKelly::JS::Property.new(:equal_node, left.value == right.value)
      end

      ## 11.13 Assignment Operators

      def visit_AssignExprNode(o)
        scope_chain[@operand.last] = o.value.accept(self)
      end

      def visit_OpEqualNode(o)
        left = o.left.accept(self)
        right = o.value.accept(self)
        left.value = right.value
        left.function = right.function
        left
      end

      def visit_OpPlusEqualNode(o)
        o.left.accept(self).value += o.value.accept(self).value
      end


      ## 12 Statements

      ## 12.1 Block
      def visit_BlockNode(o)
        o.value.accept(self)
      end

      ## 12.2 Variable Statement
      def visit_VarStatementNode(o)
        o.value.each { |x| x.accept(self) }
      end

      def visit_VarDeclNode(o)
        @operand << o.name
        o.value.accept(self) if o.value
        @operand.pop
      end

      ## 12.3 Empty Statement
      def visit_EmptyStatementNode(o)
        # do nothing
      end

      ## 12.4 Expression Statement
      def visit_ExpressionStatementNode(o)
        o.value.accept(self)
      end

      ## 12.5 If Statement
      def visit_IfNode(o)
        if to_boolean(o.conditions.accept(self)).value
          o.value.accept(self)
        elsif o.else
          o.else.accept(self)
        end
      end

      ## 12.6 Iteration Statements
      def visit_DoWhileNode(o)
        begin
          o.left.accept(self)
        end while to_boolean(o.value.accept(self)).value
      end

      def visit_WhileNode(o)
        while to_boolean(o.left.accept(self)).value
          o.value.accept(self)
        end
      end

      ## 12.9 The 'return' Statement
      def visit_ReturnNode(o)
        scope_chain.return = o.value.accept(self)
      end


      ## 13 Function Definition

      def visit_FunctionDeclNode(o)
      end

      def visit_FunctionBodyNode(o)
        o.value.accept(self)
        scope_chain.return
      end


      %w{
        ArrayNode BitAndNode BitOrNode
        BitXOrNode BracketAccessorNode BreakNode
        CaseBlockNode CaseClauseNode CommaNode ConditionalNode
        ConstStatementNode ContinueNode DeleteNode
        ElementNode
        ForInNode ForNode
        FunctionExprNode GetterPropertyNode
        InNode InstanceOfNode LabelNode LeftShiftNode
        LogicalAndNode LogicalOrNode
        NotEqualNode NotStrictEqualNode
        ObjectLiteralNode OpAndEqualNode OpDivideEqualNode
        OpLShiftEqualNode OpMinusEqualNode OpModEqualNode
        OpMultiplyEqualNode OpOrEqualNode OpRShiftEqualNode
        OpURShiftEqualNode OpXOrEqualNode ParameterNode
        PropertyNode RegexpNode RightShiftNode
        SetterPropertyNode StrictEqualNode
        SwitchNode ThrowNode TryNode
        UnsignedRightShiftNode
        WithNode
      }.each do |type|
        define_method(:"visit_#{type}") do |o|
          raise "#{type} not defined"
        end
      end

      private
      def to_number(object)
        return RKelly::JS::Property.new('0', 0) unless object.value

        return_val =
          case object.value
          when :undefined
            RKelly::JS::NaN.new
          when false
            0
          when true
            1
          when Numeric
            object.value
          when ::String
            s = object.value.gsub(/(\A[\s\xA0]*|[\s\xA0]*\Z)/n, '')
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
                RKelly::JS::NaN.new
              end
            end
          when RKelly::JS::Base
            return to_number(to_primitive(object, 'Number'))
          end
        RKelly::JS::Property.new(nil, return_val)
      end

      def to_boolean(object)
        return RKelly::JS::Property.new(false, false) unless object.value
        value = object.value
        boolean =
          case value
          when :undefined
            false
          when true
            true
          when Numeric
            value == 0 || nan?(value) ? false : true
          when ::String
            value.length == 0 ? false : true
          when RKelly::JS::Base
            true
          else
            raise
          end
        RKelly::JS::Property.new(boolean, boolean)
      end

      def to_int_32(object)
        number = to_number(object)
        value = number.value
        return number if value == 0
        if nan?(value) || infinite?(value)
          RKelly::JS::Property.new(nil, 0)
        end
        value = ((value < 0 ? -1 : 1) * value.abs.floor) % (2 ** 32)
        if value >= 2 ** 31
          RKelly::JS::Property.new(nil, value - (2 ** 32))
        else
          RKelly::JS::Property.new(nil, value)
        end
      end

      def to_primitive(object, preferred_type = nil)
        return object unless object.value
        case object.value
        when false, true, :undefined, ::String, Numeric
          RKelly::JS::Property.new(nil, object.value)
        when RKelly::JS::Base
          call_function(object.value.default_value(preferred_type))
        end
      end

      def additive_operator(operator, left, right)
        left, right = to_number(left).value, to_number(right).value

        left = nan?(left) ? 0.0/0.0 : left
        right = nan?(right) ? 0.0/0.0 : right

        result = left.send(operator, right)
        result = nan?(result) ? JS::NaN.new : result

        RKelly::JS::Property.new(operator, result)
      end

      def call_function(property, arguments = [])
        function  = property.function || property.value
        case function
        when RKelly::JS::Function
          scope_chain.new_scope { |chain|
            function.js_call(chain, *arguments)
          }
        when UnboundMethod
          RKelly::JS::Property.new(:ruby,
            function.bind(property.binder).call(*(arguments.map { |x| x.value}))
          )
        else
          RKelly::JS::Property.new(:ruby,
            function.call(*(arguments.map { |x| x.value }))
          )
        end
      end

      # 11.8.5 The Abstract Relational Comparison Algorithm
      #
      # Simplified version of the ECMA algorithm, that drops
      # the LeftFirst flag and uses #yield instead.  It also
      # incorporates the evaluation of both subexpressions.
      def relational_comparison(o)
        left = to_primitive(o.left.accept(self), "Number")
        right = to_primitive(o.value.accept(self), "Number")

        if [left, right].all? {|x| x.value.is_a?(::String) }
          RKelly::JS::Property.new(:relational_node, yield(left.value, right.value))
        else
          left = to_number(left).value
          right = to_number(right).value

          if nan?(left) || nan?(right)
            RKelly::JS::Property.new(:relational_node, false)
          else
            RKelly::JS::Property.new(:relational_node, yield(left, right))
          end
        end
      end

      # Helper to check if x is NaN.
      def nan?(x)
        x.respond_to?(:nan?) && x.nan?
      end

      # Helper to check if x is +/-infinity.
      def infinite?(x)
        x.respond_to?(:infinite?) && x.infinite?
      end

    end
  end
end
