require File.dirname(__FILE__) + "/../helper"

# ECMA-262
# Section 15.1.1.2
class GlobalObject_15_1_1_2_Test < ECMAScriptTestCase
  def setup
    super
    env = @runtime.execute("")
    @global_object = env.global_object
  end

  def test_global_infinity
    assert @global_object.has_property?('Infinity')
  end

  def test_global_infinity_attributes
    p = @global_object.get_own_property('Infinity')
    assert_equal false, p[:writable]
    assert_equal false, p[:enumerable]
    assert_equal false, p[:configurable]
  end

  def test_global_infinity_is_number_positive_infinity
    js_assert_equal('Number.POSITIVE_INFINITY', 'Infinity')
  end

  def test_this_infinity_is_number_positive_infinity
    js_assert_equal('Number.POSITIVE_INFINITY', 'this.Infinity')
  end

  def test_typeof_infinity
    js_assert_equal("'number'", 'typeof Infinity')
  end
end
