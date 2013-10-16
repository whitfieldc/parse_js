require File.dirname(__FILE__) + "/../helper"

class Statement_12_9_Return_Test < ExecuteTestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_return_without_expression
    assert_execute({ 'x' => :undefined }, <<-EOJS)
      function foo() {
        return;
      }
      var x = foo();
    EOJS
  end

  def test_basic_return
    assert_execute({ 'x' => 1 }, <<-EOJS)
      function foo() {
        return 1;
      }
      var x = foo();
    EOJS
  end

  def test_return_inside_if
    assert_execute({ 'x' => 1 }, <<-EOJS)
      function foo() {
        if (true) {
          return 1;
        }
        return 2;
      }
      var x = foo();
    EOJS
  end

  def test_return_inside_infinite_while_loop
    assert_execute({ 'x' => 5 }, <<-EOJS)
      function foo() {
        while (true) {
          return 5;
        }
      }
      var x = foo();
    EOJS
  end

  def test_return_inside_infinite_do_while_loop
    assert_execute({ 'x' => 5 }, <<-EOJS)
      function foo() {
        do {
          return 5;
        } while (true);
      }
      var x = foo();
    EOJS
  end

  def test_return_inside_infinite_for_loop
    assert_execute({ 'x' => 5 }, <<-EOJS)
      function foo() {
        for (;;) {
          return 5;
        }
      }
      var x = foo();
    EOJS
  end

end
