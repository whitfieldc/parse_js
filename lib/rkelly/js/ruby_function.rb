require 'rkelly/js/value'

module RKelly
  module JS
    class RubyFunction < Base
      def initialize(&block)
        super()
        @code = block
        self['prototype'] = JS::FunctionPrototype.new(self)
        self['toString'] = :undefined
        self['length'] = 0
      end

      def call(*args)
        JS::Value[ @code.call(*(args.map { |x| x.value })) ]
      end
    end
  end
end
