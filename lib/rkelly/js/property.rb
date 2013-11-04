module RKelly
  module JS
    # A property of an object, containing the value and various
    # attributes.  Used to represent a single property in JS::Base.
    class Property

      def initialize(attributes = {})
        @attributes = attributes
      end

      def value
        @attributes[:value]
      end

      # All attributes default to `true`, unless explicitly set to
      # `false`.
      [:writable, :enumerable, :configurable].each do |property|
        define_method(:"#{property}?") do
          !(@attributes[property] == false)
        end
      end

    end
  end
end
