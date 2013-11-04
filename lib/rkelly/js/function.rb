require 'rkelly/js/base'
require 'rkelly/js/function_prototype'

module RKelly
  module JS
    class Function < Base
      class << self
        # Initializes the global Function object.
        def define(env)
          function = JS::Function.new(env) do |this, *args|
            create(env, *args)
          end
          function['prototype'] = JS::FunctionPrototype.new(function)
          function['prototype'].prototype = env.object_prototype
          function
        end

        def create(env, *args)
          if args.length > 0
            parser = Parser.new
            body = args.pop
            tree = parser.parse("function x(#{args.join(',')}) { #{body} }")
            func = tree.value.first
            JS::Function.new(env, func.function_body, func.arguments)
          else
            JS::Function.new(env)
          end
        end
      end

      # Creates new function object (with reference to the lexical
      # environment in which it was created).
      #
      # For internal functions, a &block is given with Ruby code to execute.
      # For true JS functions, body and arguments are passed instead.
      def initialize(env, body=nil, arguments = [], &block)
        super()
        @body = body
        @block = block
        @arguments = arguments
        @env = env
        @class_name = 'Function'

        self['prototype'] = JS::Base.new
        self['prototype']['constructor'] = self
        self['prototype'].prototype = @env.object_prototype
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
          this.prototype = @env.object_prototype
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

        new_env = @env.new_declarative
        new_env.this = this

        @arguments.each_with_index { |name, i|
          new_env.record[name.value] = params[i] || :undefined
        }

        @body.accept(Visitors::FunctionVisitor.new(new_env))
        @body.accept(Visitors::EvaluationVisitor.new(new_env))
      end


    end
  end
end
