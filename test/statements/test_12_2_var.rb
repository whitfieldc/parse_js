require File.dirname(__FILE__) + "/../helper"

class Statement_12_2_Var_Test < ExecuteTestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_unassigned_var
    assert_execute({ 'x' => :undefined }, <<-EOJS)
      var x;
    EOJS
  end

  def test_simple_var
    assert_execute({ 'x' => 4 }, <<-EOJS)
      var x = 4;
    EOJS
  end

  def test_multiple_var
    assert_execute({ 'x' => 4, 'y' => 10, 'z' => 12 }, <<-EOJS)
      var x = 4, y = 10, z = 12;
    EOJS
  end

  def test_var_in_function
    assert_execute({ 'x' => 4 }, <<-EOJS)
      var x = 4;
      function foo() {
        var x = 10;
      }
      foo();
    EOJS
  end

  def test_assignment_in_function
    assert_execute({ 'x' => 10 }, <<-EOJS)
      var x = 4;
      function foo() {
        x = 10;
      }
      foo();
    EOJS
  end

  def test_var_in_anonymous_function
    assert_execute({ 'x' => 4 }, <<-EOJS)
      var x = 4;
      (function() {
        var x = 10;
      })();
    EOJS
  end

  def test_assignment_anonymous_function
    assert_execute({ 'x' => 10 }, <<-EOJS)
      var x = 4;
      (function() {
        x = 10;
      })();
    EOJS
  end

  def test_assignment_in_function_with_var_defined_elsewhere_in_function
    assert_execute({ 'x' => 4 }, <<-EOJS)
      var x = 4;
      function foo() {
        x = 10;
        if (false) {
          var x;
        }
      }
      foo();
    EOJS
  end

  def test_assignment_in_function_with_var_defined_in_anonymous_function
    assert_execute({ 'x' => 10 }, <<-EOJS)
      var x = 4;
      function foo() {
        x = 10;
        (function() {
          var x;
        })();
      }
      foo();
    EOJS
  end

end
