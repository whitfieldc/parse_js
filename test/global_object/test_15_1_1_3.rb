require File.dirname(__FILE__) + "/../helper"

# ECMA-262
# Section 15.1.1.3
class GlobalObject_15_1_1_3_Test < ECMAScriptTestCase
  def setup
    super
    env = @runtime.execute("")
    @global_object = env.global_object
  end

  def test_global_undefined
    assert @global_object.has_property?('undefined')
  end

  def test_global_undefined_attributes
    p = @global_object.get_own_property('undefined')
    assert_equal false, p[:writable]
    assert_equal false, p[:enumerable]
    assert_equal false, p[:configurable]
  end

  def test_undefined_is_void_0
    js_assert_equal('void 0', 'undefined')
  end
end
