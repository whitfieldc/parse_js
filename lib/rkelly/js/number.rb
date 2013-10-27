module RKelly
  module JS
    class Number < Base
      def initialize()
        super()
        self['MAX_VALUE'] = VALUE[1.797693134862315e+308]
        self['MIN_VALUE'] = VALUE[1.0e-306]
        self['NaN']       = VALUE[JS::NaN.new]
        self['POSITIVE_INFINITY'] = VALUE[1.0/0.0]
        self['NEGATIVE_INFINITY'] = VALUE[-1.0/0.0]
      end
    end
  end
end
