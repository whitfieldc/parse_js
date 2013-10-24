require 'rkelly/nodes'
require 'rkelly/js/constructable'

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

      include Constructable

      def initialize(body=nil, arguments = [], outer_environment=nil)
        super()
        @body = body || Nodes::FunctionBodyNode.new(Nodes::SourceElementsNode.new([]))
        @arguments = arguments
        @outer_environment = outer_environment
        @prototype = JS::FunctionPrototype.new(self)
        self['toString'] = VALUE[:undefined]
        self['length'] = VALUE[arguments.length]
      end

      def call(this, *params)
        env = @outer_environment.new_declarative
        env.this = this

        @arguments.each_with_index { |name, i|
          env.record[name.value] = params[i] || RKelly::Runtime::UNDEFINED
        }

        @body.accept(RKelly::Visitors::FunctionVisitor.new(env))
        @body.accept(RKelly::Visitors::EvaluationVisitor.new(env))
      end

    end
  end
end
