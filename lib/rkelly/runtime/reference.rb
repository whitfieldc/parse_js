require 'rkelly/js/base'
require 'rkelly/nodes'

module RKelly
  class Runtime
    # A wrapper around syntax node, to provide a unified interface for
    # setting/getting values of both variables and object properties.
    class Reference
      # In case of member expression: the related object.
      # In case of variable: the current lexical environment.
      # Else: nil
      attr_reader :binder

      def initialize(node, environment, visitor)
        @node = node
        case node
        when Nodes::DotAccessorNode
          @binder = node.value.accept(visitor)
          @key = node.accessor
        when Nodes::BracketAccessorNode
          @binder = node.value.accept(visitor)
          @key = node.accessor.accept(visitor)
        when Nodes::ResolveNode
          @binder = environment
          @key = node.value
        when Nodes::VarDeclNode
          # Used to handle var declaration in for-in loop.  We grab
          # the name of the var to treat it as ResolveNode, but
          # additonally evaluate the node in case there's some
          # initialization of the variable.
          @binder = environment
          node.accept(visitor)
          @key = node.name
        else
          @value = node.accept(visitor)
          @binder = nil
        end
      end

      # True when we're dealing with a member expression.
      def bound_to_object?
        @binder.is_a?(JS::Base)
      end

      def value=(value)
        if @binder
          @binder[@key] = value
        else
          raise "Can't assign to #{@node.class}"
        end
      end

      def value
        if @binder
          @binder[@key]
        else
          @value
        end
      end

      def delete!
        if bound_to_object?
          @binder.delete(@key)
        else
          false
        end
      end

    end
  end
end
