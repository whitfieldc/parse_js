require 'parse_js/js'
require 'parse_js/runtime/scope_chain'

module ParseJS
  class Runtime
    UNDEFINED = ParseJS::JS::Property.new(:undefined, :undefined)

    def initialize
      @parser = Parser.new
      @scope  = ScopeChain.new
    end

    # Execute +js+
    def execute(js)
      function_visitor  = Visitors::FunctionVisitor.new(@scope)
      eval_visitor      = Visitors::EvaluationVisitor.new(@scope)
      tree = @parser.parse(js)
      function_visitor.accept(tree)
      eval_visitor.accept(tree)
      @scope
    end

    def call_function(function_name, *args)
      function = @scope[function_name].value
      @scope.new_scope { |chain|
        function.js_call(chain, *(args.map { |x|
          ParseJS::JS::Property.new(:param, x)
        }))
      }.value
    end

    def define_function(function, &block)
      @scope[function.to_s].function = block
    end
  end
end
