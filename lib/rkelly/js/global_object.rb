module RKelly
  module JS
    class GlobalObject < Base
      # Access to the built-in Object.prototype
      attr_reader :object_prototype

      def initialize
        super
        @class_name = 'GlobalObject'
      end

      # Here the actual initialization of properties happens, as we
      # need the environment to be available before construction of
      # function objects can begin.
      def init_in_environment(env)
        @object_prototype = JS::ObjectPrototype.new(env)

        self['NaN'] = JS::NaN.new

        self['Infinity'] = 1.0/0.0

        self['undefined'] = :undefined

        self['Object'] = JS::Function.new(env)
        self['Object']['prototype'] = @object_prototype

        self['Function'] = JS::Function.define(env)

        self['Number'] = JS::Number.new

        self['String'] = JS::String.new(env)

        self['Math'] = JS::Math.new
      end
    end
  end
end
