module RKelly
  module JS

    class Object
      # Initializes the global Object object.
      def self.define(env)
        obj = JS::Function.new(env)
        obj['prototype'] = env.object_prototype
        obj
      end
    end

  end
end
