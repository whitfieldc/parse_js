require File.dirname(__FILE__) + "/../helper"

class Expressions_11_4_2_Void_Test < Test::Unit::TestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_void_1
    env = @runtime.execute("var x = void(10);")
    assert_equal :undefined, env['x']
  end
end
