require File.dirname(__FILE__) + "/../helper"

class Statement_12_1_Block_Test < ExecuteTestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_empty_block
    assert_execute({ 'x' => 'pass' },
      "var x = 'pass'; { }")
  end

  def test_block_with_one_statement
    assert_execute({ 'x' => 'pass' },
      "{ var x = 'pass'; }")
  end

  def test_block_with_multiple_statements
    assert_execute({ 'x' => 'pass' },
      "{ var x = 'fail'; x = 'pass'; }")
  end

end
