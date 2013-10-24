require 'rkelly/env/declarative_record'
require 'rkelly/env/object_record'
require 'rkelly/js/global_object'
require 'rkelly/js/value'

module RKelly
  module Env
    # Represents a Lexical Environment that points to its outer
    # Lexical Environment (or nil) and hosts an environment record
    # (ObjectRecord or DeclarativeRecord) which stores the
    # actual variable bindings.
    class Lexical
      attr_reader :record, :outer, :global_object

      # ThisBinding within this execution context.
      attr_accessor :this

      def initialize(outer=nil, record=Env::DeclarativeRecord.new)
        @record = record
        @outer = outer
        @this = nil

        # Always maintain a reference to the global object, so we can
        # quickly return it without special lookup.
        if outer && outer.global_object
          @global_object = outer.global_object
        else
          @global_object = JS::VALUE[record.obj]
        end

        @this = @global_object
      end

      # Static factory method for the global environment.
      def self.new_global
        Env::Lexical.new(nil, Env::ObjectRecord.new(JS::GlobalObject.new))
      end

      # Creates new Declarative Environment with reference to this env.
      def new_declarative
        Env::Lexical.new(self)
      end

      # Creates new Object Environment with reference to this env.
      def new_object(obj)
        Env::Lexical.new(self, Env::ObjectRecord.new(obj))
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
