require 'rkelly/js/constructable'

module RKelly
  module JS
    class RubyFunction < Base
      include Constructable

      def initialize(&block)
        super()
        @code = block || lambda {|this, *args| }
        @prototype = JS::FunctionPrototype.new(self)
        self['length'] = 0
      end

      def call(this, *args)
        @code.call(this, *args)
      end
    end
  end
end
