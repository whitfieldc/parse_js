module RKelly
  module JS
    class String < Base
      class << self
        def create(*args)
          self.new(args.first || '')
        end
      end

      def initialize()
        super()
        self['fromCharCode'] = VALUE[unbound_method(:fromCharCode) { |*args|
          args.map { |x| x.chr }.join
        }]
      end
    end
  end
end
