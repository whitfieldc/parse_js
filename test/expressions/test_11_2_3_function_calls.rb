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
end
