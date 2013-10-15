require File.dirname(__FILE__) + "/../helper"

class Statement_12_5_1_Test < ExecuteTestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_if_true
    assert_execute({ 'x' => 'pass' },
      "var x; if(true) x = 'pass'; else x = 'fail';")
  end

  def test_if_false
    assert_execute({ 'x' => 'pass' },
      "var x; if(false) x = 'fail'; else x = 'pass';")
  end

  def test_if_zero
    assert_execute({ 'x' => 'pass' },
      "var x; if(0) x = 'fail'; else x = 'pass';")
  end

  def test_if_one
    assert_execute({ 'x' => 'pass' },
      "var x; if(1) x = 'pass'; else x = 'fail';")
  end

  def test_if_empty_string
    assert_execute({ 'x' => 'pass' },
      "var x; if('') x = 'fail'; else x = 'pass';")
  end

  def test_if_true_without_else
    assert_execute({ 'x' => 'pass' },
      "var x; if(true) x = 'pass';")
  end

  def test_if_false_without_else
    assert_execute({ 'x' => 'pass' },
      "var x = 'pass'; if(false) x = 'fail';")
  end
end
