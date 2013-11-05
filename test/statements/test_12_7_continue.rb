require File.dirname(__FILE__) + "/../helper"

class Statement_12_7_Continue_Test < ExecuteTestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_continue_in_do_while_loop
    assert_execute({ 'sum' => 4 }, <<-EOJS)
      var sum = 0;
      var i = 0;
       do {
        if (i % 2 == 0) {
          i++;
          continue;
        }
        sum += i;
        i++;
      } while (i < 5);
    EOJS
  end

  def test_continue_in_while_loop
    assert_execute({ 'sum' => 4 }, <<-EOJS)
      var sum = 0;
      var i = 0;
      while (i < 5) {
        if (i % 2 == 0) {
          i++;
          continue;
        }
        sum += i;
        i++;
      }
    EOJS
  end

  def test_continue_in_for_loop
    assert_execute({ 'sum' => 4 }, <<-EOJS)
      var sum = 0;
      for (var i=0; i < 5; i++) {
        if (i % 2 == 0) continue;
        sum += i;
      }
    EOJS
  end

  def test_continue_in_for_in_loop
    assert_execute({ 'sum' => 4 }, <<-EOJS)
      var obj = {a: 1, b: 2, c: 3};
      var sum = 0;
      for (var k in obj) {
        if (k == 'b') continue;
        sum += obj[k];
      }
    EOJS
  end

  def test_continue_in_nested_loop
    assert_execute({ 'sum' => 10 }, <<-EOJS)
      var sum = 0;
      var ok = true;
      for (var i=0; i < 5; i++) {
        while (ok) {
          ok = false;
          continue;
          ok = true;
        }
        sum += i;
      }
    EOJS
  end

end
