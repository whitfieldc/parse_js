require File.dirname(__FILE__) + "/../helper"

class Statement_12_6_2_While_Test < ExecuteTestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_while
    assert_execute({ 'x' => 10 },
      "var x = 0; while (x < 10) x++;")
  end

  def test_while_with_never_executing_body
    assert_execute({ 'x' => 0 },
      "var x = 0; while (false) x++;")
  end

end
