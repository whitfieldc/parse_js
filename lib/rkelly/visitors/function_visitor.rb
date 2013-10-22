require 'rkelly/js'

module RKelly
  module Visitors
    class FunctionVisitor < Visitor

      VALUE = RKelly::JS::VALUE

      def initialize(environment)
        super()
        @environment = environment
      end

      def visit_VarDeclNode(o)
        @environment.record[o.name] = VALUE[:undefined]
      end

      def visit_FunctionDeclNode(o)
        @environment.record[o.value] = VALUE[RKelly::JS::Function.new(o.function_body, o.arguments, @environment)]
      end

      def visit_FunctionExprNode(o)
        # avoid recursing inside functions.
      end

    end
  end
end
