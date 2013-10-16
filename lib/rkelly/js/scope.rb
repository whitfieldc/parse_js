module RKelly
  module JS
    class Scope < Base
      attr_reader :return

      def initialize
        super
        @return = nil
        @returned = false
      end

      def return=(value)
        @returned = true
        @return = value
      end

      def returned?
        @returned
      end

    end
  end
end
