require 'rkelly/js'

module RKelly
  module Visitors
    class FunctionVisitor < Visitor

      VALUE = RKelly::JS::Value

      attr_reader :scope_chain

      def initialize(scope)
        super()
        @scope_chain = scope
      end

      def visit_VarDeclNode(o)
        scope_chain[o.name] = VALUE[:undefined]
      end

      def visit_FunctionDeclNode(o)
        scope_chain[o.value] = VALUE[RKelly::JS::Function.new(o.function_body, o.arguments)]
      end

      def visit_FunctionExprNode(o)
        # avoid recursing inside functions.
      end

    end
  end
end
