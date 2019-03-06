require 'parse_js/nodes/binary_node'

module ParseJS
  module Nodes
    class CaseClauseNode < BinaryNode
      def initialize(left, src = SourceElementsNode.new([]))
        super
      end
    end
  end
end
