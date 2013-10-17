module RKelly
  module JS
    # Object Environment Record is associated with an object, on which
    # it operates, setting and getting its properties.
    #
    # To create an uninitialized binding, simply assign :undefined:
    #
    #   env_record[var_name] = VALUE[:undefined]
    #
    class ObjectEnvironmentRecord
      def initialize(obj)
        @obj = obj
      end

      def has_binding?(name)
        @obj.has_property?(name)
      end

      def delete(name)
        @obj.delete(name)
      end

      def [](name)
        @obj[name]
      end

      def []=(name, value)
        # as a temporary hack, unwrap the value
        @obj[name] = value.value
      end
    end
  end
end
