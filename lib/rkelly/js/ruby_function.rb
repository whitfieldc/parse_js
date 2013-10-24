require 'rkelly/js/value'

module RKelly
  module JS
    class RubyFunction < Base
      def initialize(&block)
        super()
        @code = block
        @prototype = JS::FunctionPrototype.new(self)
        self['toString'] = VALUE[:undefined]
        self['length'] = VALUE[0]
      end

      def call(this, *args)
        VALUE[ @code.call(this.value, *(args.map { |x| x.value })) ]
      end
    end
  end
end
