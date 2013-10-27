module RKelly
  module JS
    class GlobalObject < Base
      def initialize
        super
        @class_name = 'GlobalObject'

        self['NaN'] = VALUE[JS::NaN.new]
        self['NaN'].attributes << :dont_enum
        self['NaN'].attributes << :dont_delete

        self['Infinity'] = VALUE[1.0/0.0]
        self['Infinity'].attributes << :dont_enum
        self['Infinity'].attributes << :dont_delete

        self['undefined'] = VALUE[:undefined]
        self['undefined'].attributes << :dont_enum
        self['undefined'].attributes << :dont_delete

        self['Object'] = VALUE[JS::RubyFunction.new]
        self['Object'].value['prototype'] = VALUE[JS::ObjectPrototype.new]

        self['Number'] = VALUE[JS::Number.new]
        self['Number'].function = lambda { |*args|
          JS::Number.create(*args)
        }

        self['String'] = VALUE[JS::String.new('')]
        self['String'].function = lambda { |*args|
          JS::String.create(*args)
        }
      end
    end
  end
end
