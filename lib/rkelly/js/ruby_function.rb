require 'rkelly/js/value'

module RKelly
  module JS
    class RubyFunction < Base
      def initialize(&block)
        super()
        @code = block
        self['prototype'] = VALUE[JS::FunctionPrototype.new(self)]
        self['toString'] = VALUE[:undefined]
        self['length'] = VALUE[0]
      end

      def call(*args)
        VALUE[ @code.call(*(args.map { |x| x.value })) ]
      end
    end
  end
end
