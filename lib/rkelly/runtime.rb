require 'rkelly/js/function'
require 'rkelly/env/lexical'

module RKelly
  class Runtime

    def initialize
      @parser = Parser.new
      @env = Env::Lexical.new_global
    end

    # Execute +js+
    def execute(js)
      function_visitor  = Visitors::FunctionVisitor.new(@env)
      eval_visitor      = Visitors::EvaluationVisitor.new(@env)
      tree = @parser.parse(js)
      function_visitor.accept(tree)
      eval_visitor.accept(tree)
      @env
    end

    def call_function(function_name, *args)
      function = @env[function_name]
      this = @env.global_object
      function.call(this, *args)
    end

    def define_function(name, &block)
      @env.record[name.to_s] = JS::Function.new(@env, &block)
    end
  end
end
