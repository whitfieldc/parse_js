require File.dirname(__FILE__) + "/../helper"

class Statement_12_8_Break_Test < ExecuteTestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_break_in_do_while_loop
    assert_execute({ 'x' => 4 }, <<-EOJS)
      var x = 0;
      do {
        if (x > 3) break;
        x++;
      } while (x < 10);
    EOJS
  end

  def test_break_in_while_loop
    assert_execute({ 'x' => 4 }, <<-EOJS)
      var x = 0;
      while (x < 10) {
        if (x > 3) break;
        x++;
      }
    EOJS
  end

  def test_break_in_for_loop
    assert_execute({ 'x' => 4 }, <<-EOJS)
      for (var x=0; x<10; x++) {
        if (x > 3) break;
      }
    EOJS
  end

  def test_break_in_for_in_loop
    assert_execute({ 'sum' => 0 }, <<-EOJS)
      var obj = {a: 4};
      var sum = 0;
      for (var k in obj) {
        if (obj[k] == 4) break;
        sum += obj[k];
      }
    EOJS
  end

  def test_break_in_nested_loop
    assert_execute({ 'x' => 10 }, <<-EOJS)
      for (var x=0; x<10; x++) {
        while (true) {
          break;
        }
      }
    EOJS
  end

end
