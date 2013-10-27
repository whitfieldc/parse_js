module RKelly
  module JS
    module Constructable

      # The shared #construct method for Function and RubyFunction
      def construct(*args)
        this = JS::Base.new()
        if has_property?('prototype')
          this.prototype = self['prototype']
        else
          this.prototype = JS::ObjectPrototype.new
        end

        res = call(this, *args)
        if res.respond_to?(:class_name) && res.class_name == "Object"
          return res
        else
          return this
        end
      end

    end
  end
end
