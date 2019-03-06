require 'parse_js/nodes/if_node'

module ParseJS
  module Nodes
    class ConditionalNode < IfNode
      def initialize(test, true_block, else_block)
        super
      end
    end
  end
end
