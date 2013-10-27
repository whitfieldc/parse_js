module RKelly
  module JS
    class GlobalObject < Base
      def initialize
        super
        @class_name = 'GlobalObject'

        self['NaN'] = JS::NaN.new

        self['Infinity'] = 1.0/0.0

        self['undefined'] = :undefined

        self['Object'] = JS::RubyFunction.new
        self['Object']['prototype'] = JS::ObjectPrototype.new

        self['Number'] = JS::Number.new

        self['String'] = JS::String.new

        self['Math'] = JS::Math.new
      end
    end
  end
end
