module RKelly
  module JS
    class GlobalObject < Base
      def initialize
        super
        @class_name = 'GlobalObject'

        self['NaN'] = JS::NaN.new

        self['Infinity'] = 1.0/0.0

        self['undefined'] = :undefined

        self['Object'] = JS::Function.new
        self['Object']['prototype'] = JS::ObjectPrototype.new

        self['Function'] = JS::Function.new do |this, *args|
          JS::Function.create(*args)
        end
        self['Function']['prototype'] = JS::FunctionPrototype.new(self['Function'])
        self['Function']['prototype'].prototype = self['Object']['prototype']

        self['Number'] = JS::Number.new

        self['String'] = JS::String.new

        self['Math'] = JS::Math.new
      end
    end
  end
end
