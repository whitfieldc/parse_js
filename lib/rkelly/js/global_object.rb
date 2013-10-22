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

        self['Array'] = VALUE[JS::RubyFunction.new do |*args|
          JS::Array.create(*args)
        end]

        self['Object'] = VALUE[JS::RubyFunction.new do |*args|
          JS::Object.create(*args)
        end]

        self['Math'] = VALUE[JS::Math.new]

        self['Function'] = VALUE[JS::RubyFunction.new do |*args|
          JS::Function.create(*args)
        end]

        self['Number'] = VALUE[JS::Number.new]
        self['Number'].function = lambda { |*args|
          JS::Number.create(*args)
        }

        self['Boolean'] = VALUE[JS::RubyFunction.new do |*args|
          JS::Boolean.create(*args)
        end]

        self['String'] = VALUE[JS::String.new('')]
        self['String'].function = lambda { |*args|
          JS::String.create(*args)
        }
      end
    end
  end
end
