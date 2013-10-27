module RKelly
  module JS
    class String < Base
      def initialize()
        super()
        self['fromCharCode'] = VALUE[RubyFunction.new do |this, *args|
            args.map { |x| x.chr }.join
        end]
      end
    end
  end
end
