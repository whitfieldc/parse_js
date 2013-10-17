module RKelly
  class Runtime
    # The Completion type is used to explain the behaviour of
    # statements (break, continue, return and throw) that perform
    # nonlocal transfers of control.
    class Completion

      # A shorthand for the constructor
      def self.[](type=:normal, value=nil, target=nil)
        Completion.new(type, value, target)
      end

      attr_reader :type, :value, :target

      # Creates a new completion.
      #
      # - type is one of: normal, break, continue, return, throw
      # - value is a JS value or nil
      # - target is JS identifier or empty
      #
      def initialize(type=:normal, value=nil, target=nil)
        @type = type
        @value = value
        @target = target
      end

      # Any completion with a type other than normal is an
      # "abrupt completion".
      def abrupt?
        @type != :normal
      end

    end
  end
end
