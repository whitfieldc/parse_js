require File.dirname(__FILE__) + "/helper"

class FunctionVisitorTest < Test::Unit::TestCase
  def setup
    @parser = RKelly::Parser.new
    @env = RKelly::Env::Lexical.new_global
    @visitor = RKelly::Visitors::FunctionVisitor.new(@env)
  end

  def test_function
    tree = @parser.parse('function foo() { var x = 10; }')
    @visitor.accept(tree)
    assert @env['foo']

    tree = @parser.parse('function foo() { var x = 10; function bar() {}; }')
    @visitor.accept(tree)
    assert @env['foo']
    assert !@env['bar']
  end

  def test_function_call
    tree = @parser.parse('var x = foo(); function foo() { return 10; }')
    @visitor.accept(tree)
    assert @env['foo']
  end
end
