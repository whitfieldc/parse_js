require File.dirname(__FILE__) + "/../helper"

class Statement_12_10_With_Test < ExecuteTestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_accessing_values_in_object
    assert_execute({ 'x' => 3 }, <<-EOJS)
      var x;
      var obj = {a: 1, b: 2};
      with (obj) {
        x = a + b;
      }
    EOJS
  end

  def test_setting_values_in_object
    assert_execute({ 'x' => 10 }, <<-EOJS)
      var x;
      var obj = {a: 1};
      with (obj) {
        a = 10;
      }
      x = obj.a;
    EOJS
  end

  def test_accessing_valuses_in_outer_environment
    assert_execute({ 'x' => 15 }, <<-EOJS)
      var x;
      var y = 5;
      var obj = {a: 1};
      with (obj) {
        x = y + 10;
      }
    EOJS
  end

end
