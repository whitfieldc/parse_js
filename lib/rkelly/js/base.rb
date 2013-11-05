require 'rkelly/js/property'

module RKelly
  module JS
    class Base
      attr_reader :properties, :value, :class_name
      attr_accessor :prototype
      def initialize
        @properties = {}
        @value = self
        # The [[Class]] internal property from ECMASCript spec.
        @class_name = "Object"
        @prototype = nil
      end

      def [](name)
        return @properties[name].value if has_own_property?(name)

        if @prototype
          @prototype[name]
        else
          :undefined
        end
      end

      def []=(name, value)
        define_own_property(name, {:value => value})
      end

      def can_put?(name)
        if !has_own_property?(name)
          if @prototype
            return @prototype.can_put?(name)
          else
            return true
          end
        end

        @properties[name].writable?
      end

      def has_property?(name)
        return true if has_own_property?(name)

        if @prototype
          @prototype.has_property?(name)
        else
          false
        end
      end

      def delete(name)
        return true unless has_own_property?(name)

        if @properties[name].configurable?
          @properties.delete(name)
          true
        else
          false
        end
      end

      def define_own_property(name, attributes)
        return unless can_put?(name)
        @properties[name] = JS::Property.new(attributes)
      end

      def get_own_property(name)
        return :undefined unless has_own_property?(name)

        p = @properties[name]
        return {
          :value => p.value,
          :writable => p.writable?,
          :configurable => p.configurable?,
          :enumerable => p.enumerable?,
        }
      end

      def has_own_property?(name)
        @properties.has_key?(name)
      end

      def default_value(hint)
        case hint
        when 'Number'
          value_of = self['valueOf']
          if value_of.is_a?(JS::Function)
            return value_of
          end
          to_string = self['toString']
          if to_string.is_a?(JS::Function)
            return to_string
          end
        end
      end

    end
  end
end
