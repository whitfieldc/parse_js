require File.dirname(__FILE__) + "/helper"

class RuntimeTest < Test::Unit::TestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_call_function
    @runtime.execute("function foo(a) { return a + 2; }")
    assert_equal(12, @runtime.call_function("foo", 10))
  end

  def test_define_function
    @runtime.define_function(:one) do |*args|
      return 1
    end
    @runtime.execute("one();")
  end

  def test_define_function_and_call_function
    @runtime.define_function(:one) do |*args|
      return 1
    end
    assert_equal(1, @runtime.call_function("one"))
  end

end
