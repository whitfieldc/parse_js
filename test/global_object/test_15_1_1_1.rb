require File.dirname(__FILE__) + "/../helper"

# ECMA-262
# Section 15.1.1.1
class GlobalObject_15_1_1_1_Test < ECMAScriptTestCase
  def test_nan
    env = RKelly::Env::Lexical.new_global
    assert env.global_object.has_property?('NaN')
  end

  def test_global_nan
    js_assert_equal('Number.NaN', 'NaN')
  end

  def test_this_nan
    js_assert_equal('Number.NaN', 'this.NaN')
  end

  def test_typeof_nan
    js_assert_equal("'number'", 'typeof NaN')
  end
end
