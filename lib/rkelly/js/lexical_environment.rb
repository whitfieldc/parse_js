module RKelly
  module JS
    # Represents a Lexical Environment that points to its outer
    # Lexical Environment (or nil) and hosts an environment record
    # (Object- or DeclarativeEnvironmentRecord) which stores the
    # actual variable bindings.
    class LexicalEnvironment
      attr_reader :record, :outer

      def initialize(outer=nil, record=DeclarativeEnvironmentRecord.new)
        @record = record
        @outer = outer
      end

      # Static factory method for the global environment.
      def self.new_global_environment
        LexicalEnvironment.new(nil, ObjectEnvironmentRecord.new(GlobalObject.new))
      end

      # Creates new Declarative Environment with reference to this env.
      def new_declarative_environment
        LexicalEnvironment.new(self)
      end

      # Creates new Object Environment with reference to this env.
      def new_object_environment(obj)
        LexicalEnvironment.new(self, ObjectEnvironmentRecord.new(obj))
      end

      # Retrieves the variable (Property object) from this or one of
      # the outer environments.
      def [](name)
        if @record.has_binding?(name)
          @record[name]
        elsif @outer
          @outer[name]
        end
      end

    end
  end
end
