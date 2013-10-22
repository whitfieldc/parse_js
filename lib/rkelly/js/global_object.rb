module RKelly
  module JS
    class GlobalObject < Base
      def initialize
        super
        self['class']     = 'GlobalObject'
        self['NaN']       = JS::NaN.new
        self['NaN'].attributes << :dont_enum
        self['NaN'].attributes << :dont_delete

        self['Infinity']  = 1.0/0.0
        self['Infinity'].attributes << :dont_enum
        self['Infinity'].attributes << :dont_delete

        self['undefined'] = :undefined
        self['undefined'].attributes << :dont_enum
        self['undefined'].attributes << :dont_delete

        self['Array'] = JS::RubyFunction.new do |*args|
          JS::Array.create(*args)
        end

        self['Object'] = JS::RubyFunction.new do |*args|
          JS::Object.create(*args)
        end

        self['Math'] = JS::Math.new

        self['Function'] = JS::RubyFunction.new do |*args|
          JS::Function.create(*args)
        end

        self['Number'] = JS::Number.new
        self['Number'].function = lambda { |*args|
          JS::Number.create(*args)
        }

        self['Boolean'] = JS::RubyFunction.new do |*args|
          JS::Boolean.create(*args)
        end

        self['String'] = JS::String.new('')
        self['String'].function = lambda { |*args|
          JS::String.create(*args)
        }
      end
    end
  end
end
