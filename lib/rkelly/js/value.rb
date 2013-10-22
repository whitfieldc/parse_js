module RKelly
  module JS

    # Helper class with one static method for creation of simple value
    # objects in EvaluationVisitor without having to instantiate
    # RKelly::JS::Property explicitly.
    class VALUE
      def self.[](value)
        RKelly::JS::Property.new(nil, value)
      end
    end

  end
end
