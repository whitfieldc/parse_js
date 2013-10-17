module RKelly
  module JS
    class Scope < Base

      def initialize(parent_scope=nil)
        super()
        @parent = parent_scope
      end

      # Returns the parent scope
      def parent
        @parent
      end

    end
  end
end
