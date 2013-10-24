require 'rkelly/js/constructable'

module RKelly
  module JS
    class RubyFunction < Base
      include Constructable

      def initialize(&block)
        super()
        @code = block || lambda {|this, *args| }
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
