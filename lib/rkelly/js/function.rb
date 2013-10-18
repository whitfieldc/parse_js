module RKelly
  module JS
    class Function < Base
      class << self
        def create(*args)
          if args.length > 0
            parser = RKelly::Parser.new
            body = args.pop
            tree = parser.parse("function x(#{args.join(',')}) { #{body} }")
            func = tree.value.first
            self.new(func.function_body, func.arguments)
          else
            self.new
          end
        end
      end

      attr_reader :body, :arguments
      def initialize(body = nil, arguments = [], outer_environment=nil)
        super()
        @body = body
        @arguments = arguments
        @outer_environment = outer_environment
        self['prototype'] = JS::FunctionPrototype.new(self)
        self['toString'] = :undefined
        self['length'] = arguments.length
      end

      def call(*params)
        env = @outer_environment.new_declarative

        arguments.each_with_index { |name, i|
          env.record[name.value] = params[i] || RKelly::Runtime::UNDEFINED
        }

        function_visitor = RKelly::Visitors::FunctionVisitor.new(env)
        body.accept(function_visitor) if body

        eval_visitor = RKelly::Visitors::EvaluationVisitor.new(env)
        body.accept(eval_visitor) if body
      end
    end
  end
end
