require 'rkelly/js/base'
require 'rkelly/js/function'

module RKelly
  module JS
    # This is the object protytpe
    # ECMA-262 15.2.4
    class ObjectPrototype < Base
      def initialize(env)
        super()
        self['toString'] = JS::Function.new(env) do |this, *args|
          "[object #{this.class_name}]"
        end
      end
    end
  end
end
