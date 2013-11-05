require File.dirname(__FILE__) + "/../helper"

class Statement_12_6_4_For_In_Test < ExecuteTestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_with_var
    assert_execute({ 'sum' => 6 }, <<-EOJS)
      var obj = {a: 1, b: 2, c: 3};
      var sum = 0;
      for (var i in obj) {
        sum += obj[i];
      }
    EOJS
  end

  def test_without_var
    assert_execute({ 'sum' => 6 }, <<-EOJS)
      var obj = {a: 1, b: 2, c: 3};
      var sum = 0;
      var i;
      for (i in obj) {
        sum += obj[i];
      }
    EOJS
  end

  def test_deleting_each_element
    assert_execute({ 'a' => :undefined, 'b' => :undefined, 'c' => :undefined }, <<-EOJS)
      var obj = {a: 1, b: 2, c: 3};
      for (var i in obj) {
        delete obj[i];
      }
      var a = obj.a;
      var b = obj.b;
      var c = obj.c;
    EOJS
  end

  def test_deleting_each_element_in_first_loop_cycle
    assert_execute({ 'cycles' => 1 }, <<-EOJS)
      var obj = {a: 1, b: 2, c: 3};
      var cycles = 0;
      for (var i in obj) {
        delete obj.a;
        delete obj.b;
        delete obj.c;
        cycles++;
      }
    EOJS
  end

end
