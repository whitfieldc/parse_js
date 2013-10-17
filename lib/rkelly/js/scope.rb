module RKelly
  module JS
    class Scope < Base
      attr_reader :abort_type, :abort_value

      def initialize(parent_scope=nil)
        super()
        @parent = parent_scope
        clear_abort
      end

      # Returns the parent scope
      def parent
        @parent
      end

      # Forces execution in this scope to be aborted.
      #
      # The type is one of:
      #
      # - :return   (value is the return value)
      # - :break    (value is the label)
      # - :continue (value is the label)
      #
      def abort(type, value=nil)
        @aborted = true
        @abort_type = type
        @abort_value = value
      end

      # Called after abort has been handled.
      # Like after loop has been exited with a break statement.
      def clear_abort
        @aborted = false
        @abort_type = nil
        @abort_value = nil
      end

      # True when execution was aborted
      def aborted?
        @aborted
      end

    end
  end
end
