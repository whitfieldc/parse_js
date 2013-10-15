require File.dirname(__FILE__) + "/../helper"

class Statement_12_6_1_DoWhile_Test < ExecuteTestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_do_while
    assert_execute({ 'x' => 10 },
      "var x = 0; do x++; while (x < 10);")
  end

  def test_do_while_with_always_false_condition
    assert_execute({ 'x' => 1 },
      "var x = 0; do x++; while (false);")
  end

end
