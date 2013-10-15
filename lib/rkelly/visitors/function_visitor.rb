module RKelly
  module Visitors
    class FunctionVisitor < Visitor
      attr_reader :scope_chain
      def initialize(scope)
        super()
        @scope_chain = scope
      end

      def visit_FunctionDeclNode(o)
        if o.value
          scope_chain[o.value].value = RKelly::JS::Function.new(o.function_body, o.arguments)
        end
      end

    end
  end
end
