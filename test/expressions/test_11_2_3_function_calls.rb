require File.dirname(__FILE__) + "/../helper"

class Expressions_11_2_3_Function_Calls_Test < ExecuteTestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_calling_a_simple_function
    assert_execute({ 'x' => true }, <<-EOJS)
      function foo() {
        return true;
      }
      var x = foo();
    EOJS
  end

  def test_calling_a_function_declared_inside_a_block
    assert_execute({ 'x' => true }, <<-EOJS)
      if (true) {
        function foo() {
          return true;
        }
        var x = foo();
      }
    EOJS
  end

  def test_calling_function_which_calls_a_nested_function
    assert_execute({ 'x' => 2 }, <<-EOJS)
      function foo() {
        function bar() {
          return 2;
        }
        return bar();
      }
      var x = foo();
    EOJS
  end

  def test_recursion
    assert_execute({ 'x' => 120 }, <<-EOJS)
      function factorial(n) {
        if (n == 1) {
          return 1;
        }
        else {
          return n * factorial(n-1);
        }
      }
      var x = factorial(5);
    EOJS
  end

  def test_calling_anonymous_function
    assert_execute({ 'x' => 'I have no name' }, <<-EOJS)
      var x = function() {
        return 'I have no name';
      }();
    EOJS
  end

  def test_closure
    assert_execute({ 'x' => 5 }, <<-EOJS)
      function makeAdder(a) {
        return function(b) {
          return a + b;
        };
      }
      var add2 = makeAdder(2);
      var x = add2(3);
    EOJS
  end

end
