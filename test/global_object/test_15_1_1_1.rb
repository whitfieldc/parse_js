require File.dirname(__FILE__) + "/../helper"

# ECMA-262
# Section 15.1.1.1
class GlobalObject_15_1_1_1_Test < ECMAScriptTestCase
  def setup
    super
    env = @runtime.execute("")
    @global_object = env.global_object
  end

  def test_global_nan
    assert @global_object.has_property?('NaN')
  end

  def test_global_nan_attributes
    p = @global_object.get_own_property('NaN')
    assert_equal false, p[:writable]
    assert_equal false, p[:enumerable]
    assert_equal false, p[:configurable]
  end

  def test_global_nan_is_number_nan
    js_assert_equal('Number.NaN', 'NaN')
  end

  def test_this_nan_is_number_nan
    js_assert_equal('Number.NaN', 'this.NaN')
  end

  def test_typeof_nan
    js_assert_equal("'number'", 'typeof NaN')
  end
end
