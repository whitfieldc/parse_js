module RKelly
  module JS
    # This is the object protytpe
    # ECMA-262 15.2.4
    class FunctionPrototype < Base
      def initialize(function)
        super()
        @class_name = 'Object'
        self['constructor'] = function
      end
    end
  end
end
