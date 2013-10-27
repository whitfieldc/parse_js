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
        self['fromCharCode'] = VALUE[RubyFunction.new do |this, *args|
            args.map { |x| x.chr }.join
        end]
      end
    end
  end
end
