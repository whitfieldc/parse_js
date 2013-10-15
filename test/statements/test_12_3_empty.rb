require File.dirname(__FILE__) + "/../helper"

class Statement_12_1_Empty_Test < ExecuteTestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_empty_statement
    assert_execute({ 'x' => 'pass' },
      "; var x = 'pass';")
  end

  def test_multiple_empty_statements
    assert_execute({ 'x' => 'pass' },
      ";;;;;;;; var x = 'pass';")
  end

end
