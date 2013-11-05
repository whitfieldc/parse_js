require 'rkelly/js/base'
require 'rkelly/js/object_prototype'
require 'rkelly/js/object'
require 'rkelly/js/function'
require 'rkelly/js/nan'
require 'rkelly/js/number'
require 'rkelly/js/string'
require 'rkelly/js/math'
require 'rkelly/js/error'

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

        define_frozen_property('NaN', JS::NaN.new)
        define_frozen_property('Infinity', 1.0/0.0)
        define_frozen_property('undefined', :undefined)

        self['Object'] = JS::Object.define(env)

        self['Function'] = JS::Function.define(env)

        self['Number'] = JS::Number.new

        self['String'] = JS::String.new(env)

        self['Math'] = JS::Math.new
      end

      def define_frozen_property(name, value)
        self.define_own_property(name, {
            :value => value,
            :writable => false,
            :enumerable => false,
            :configurable => false,
          })
      end
    end
  end
end
