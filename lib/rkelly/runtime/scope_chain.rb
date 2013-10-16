module RKelly
  class Runtime
    class ScopeChain
      include RKelly::JS

      def initialize(scope = Scope.new)
        @chain = [GlobalObject.new]
      end

      def <<(scope)
        @chain << scope
      end

      def has_property?(name)
        scope = @chain.reverse.find { |x|
          x.has_property?(name)
        }
        scope ? scope[name] : nil
      end

      def [](name)
        property = has_property?(name)
        return property if property
        @chain.last.properties[name]
      end

      def []=(name, value)
        @chain.last.properties[name] = value
      end

      def pop
        @chain.pop
      end

      def this
        @chain.last
      end

      def new_scope(&block)
        @chain << Scope.new
        result = yield(self)
        @chain.pop
        result
      end

      def abort(type, value=nil)
        @chain.last.abort(type, value)
      end

      def abort_type
        @chain.last.abort_type
      end

      def abort_value
        @chain.last.abort_value
      end

      def aborted?
        @chain.last.aborted?
      end

      def clear_abort
        @chain.last.clear_abort
      end
    end
  end
end
