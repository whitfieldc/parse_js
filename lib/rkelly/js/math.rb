module RKelly
  module JS
    class Math < Base
      def initialize
        super
        self['PI'] = VALUE[::Math::PI]
      end
    end
  end
end
