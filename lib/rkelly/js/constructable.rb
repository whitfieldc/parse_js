module RKelly
  module JS
    module Constructable

      # The shared #construct method for Function and RubyFunction
      def construct(*args)
        this = JS::Base.new()
        if has_property?('prototype')
          this.prototype = self['prototype'].value
        else
          this.prototype = JS::ObjectPrototype.new
        end

        res = call(this, *args)
        if res.value.respond_to?(:class_name) && res.value.class_name == "Object"
          return res
        else
          return VALUE[this]
        end
      end

    end
  end
end
