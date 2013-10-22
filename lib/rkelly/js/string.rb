module RKelly
  module JS
    class String < Base
      class << self
        def create(*args)
          self.new(args.first || '')
        end
      end

      def initialize(value)
        super()
        self['valueOf'] = VALUE[value]
        self['valueOf'].function = lambda { value }
        self['toString'] = VALUE[value]
        self['fromCharCode'] = VALUE[unbound_method(:fromCharCode) { |*args|
          args.map { |x| x.chr }.join
        }]
      end
    end
  end
end
