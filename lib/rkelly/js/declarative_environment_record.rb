module RKelly
  module JS
    # Use Ruby hash as the Declarative Environment Record, and use the
    # following methods to get/set bindings:
    #
    # - has_binding?  (mapped to #has_key?)
    # - delete
    # - []=
    # - []
    #
    # To create an uninitialized binding, simply assign :undefined:
    #
    #   env_record[var_name] = VALUE[:undefined]
    #
    class DeclarativeEnvironmentRecord < ::Hash
      alias :has_binding? :has_key?
    end
  end
end
