module RKelly
  module JS
    class Function < Base
      class << self
        def create(env, *args)
          if args.length > 0
            parser = RKelly::Parser.new
            body = args.pop
            tree = parser.parse("function x(#{args.join(',')}) { #{body} }")
            func = tree.value.first
            self.new(env, func.function_body, func.arguments)
          else
            self.new(env)
          end
        end
      end

      # Creates new function object.
      #
      # For internal functions, a &block is given with Ruby code to execute.
      # For true JS functions, body and arguments are passed instead.
      def initialize(outer_environment, body=nil, arguments = [], &block)
        super()
        @body = body
        @block = block
        @arguments = arguments
        @outer_environment = outer_environment
        @class_name = 'Function'

        self['prototype'] = JS::Base.new
        self['prototype']['constructor'] = self
        self['prototype'].prototype = @outer_environment.object_prototype
        self['length'] = @arguments.length
        self['arguments'] = nil
      end

      # Creates a new object from functions prototype and passes it to
      # the #call method as `this` argument.
      def construct(*args)
        this = JS::Base.new()
        if has_property?('prototype')
          this.prototype = self['prototype']
        else
          this.prototype = @outer_environment.object_prototype
        end

        res = call(this, *args)
        if res.respond_to?(:class_name)
          return res
        else
          return this
        end
      end

      # Executes the function.
      def call(this, *args)
        if @block
          @block.call(this, *args)
        else
          js_call(this, *args)
        end
      end

      private

      def js_call(this, *params)
        return :undefined unless @body

        env = @outer_environment.new_declarative
        env.this = this

        @arguments.each_with_index { |name, i|
          env.record[name.value] = params[i] || :undefined
        }

        @body.accept(RKelly::Visitors::FunctionVisitor.new(env))
        @body.accept(RKelly::Visitors::EvaluationVisitor.new(env))
      end


    end
  end
end
