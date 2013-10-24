module RKelly
  module JS
    class Base
      attr_reader :properties, :value, :class_name
      attr_accessor :prototype
      def initialize
        @properties = Hash.new { |h,k|
          h[k] = VALUE[:undefined]
        }
        @value = self
        # The [[Class]] internal property from ECMASCript spec.
        @class_name = "Object"
        @prototype = nil
      end

      def [](name)
        return @properties[name] if @properties.has_key?(name)
        if @prototype
          @prototype[name]
        else
          VALUE[:undefined]
        end
      end

      def []=(name, value)
        return unless can_put?(name)
        @properties[name] = value
      end

      def can_put?(name)
        if !has_property?(name)
          return true if @prototype.nil?
          return @prototype.can_put?(name)
        end
        !@properties[name].read_only?
      end

      def has_property?(name)
        return true if @properties.has_key?(name)
        return false if @prototype.nil?
        @prototype.has_property?(name)
      end

      def delete(name)
        return true unless has_property?(name)
        return false if @properties[name].dont_delete?
        @properties.delete(name)
        true
      end

      def default_value(hint)
        case hint
        when 'Number'
          value_of = self['valueOf']
          if value_of.function || value_of.value.is_a?(RKelly::JS::Function)
            return value_of
          end
          to_string = self['toString']
          if to_string.function || to_string.value.is_a?(RKelly::JS::Function)
            return to_string
          end
        end
      end

      private
      def unbound_method(name, object_id = nil, &block)
        name = "#{name}_#{self.class.to_s.split('::').last}_#{object_id}"
        unless RKelly::JS::Base.instance_methods.include?(name.to_sym)
          RKelly::JS::Base.class_eval do
            define_method(name, &block)
          end
        end
        RKelly::JS::Base.instance_method(name)
      end
    end
  end
end
