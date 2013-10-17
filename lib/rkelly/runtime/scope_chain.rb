module RKelly
  class Runtime
    class ScopeChain
      include RKelly::JS

      def initialize(scope = GlobalObject.new)
        @current = scope
      end

      def has_property?(name)
        scope = @current
        while scope
          break if scope.has_property?(name)
          scope = scope.parent
        end

        scope ? scope[name] : nil
      end

      def [](name)
        property = has_property?(name)
        return property if property
        @current.properties[name]
      end

      def []=(name, value)
        @current.properties[name] = value
      end

      def pop
        @current = @current.parent
      end

      def this
        @current
      end

      def new_scope(&block)
        @current = Scope.new(@current)
        result = yield(self)
        @current = @current.parent
        result
      end

    end
  end
end
