require 'rkelly/js/function'

module RKelly
  module Visitors
    class FunctionVisitor < Visitor

      def initialize(environment)
        super()
        @environment = environment
      end

      def visit_VarDeclNode(o)
        @environment.record[o.name] = :undefined
      end

      def visit_FunctionDeclNode(o)
        @environment.record[o.value] = JS::Function.new(@environment, o.function_body, o.arguments)
      end

      def visit_FunctionExprNode(o)
        # avoid recursing inside functions.
      end

    end
  end
end
