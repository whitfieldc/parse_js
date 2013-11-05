module RKelly
  module JS

    # Builtin JS Error classes

    class Error < StandardError
    end

    class EvalError < Error
    end

    class RangeError < Error
    end

    class ReferenceError < Error
    end

    class SyntaxError < Error
    end

    class TypeError < Error
    end

    class URIError < Error
    end

  end
end
