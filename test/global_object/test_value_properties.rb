require File.dirname(__FILE__) + "/../helper"

# ECMA-262 Section 15.1.1
class GlobalObject_Value_Properties_Test < ECMAScriptTestCase
  def setup
    super
    # Bit of a hack to access the environment
    env = @runtime.execute("")
    @global_object = env.global_object
  end

  # Shared tests for all value properties

  ['NaN', 'Infinity', 'undefined'].each do |property|

    define_method(:"test_global_#{property}") do
      assert @global_object.has_property?(property)
    end

    [:writable, :enumerable, :configurable].each do |attribute|
      define_method(:"test_global_#{property}_is_not_#{attribute}") do
        p = @global_object.get_own_property(property)
        assert_equal false, p[attribute]
      end
    end

  end

  # NaN

  def test_global_nan_is_number_nan
    js_assert_equal('Number.NaN', 'NaN')
  end

  def test_this_nan_is_number_nan
    js_assert_equal('Number.NaN', 'this.NaN')
  end

  def test_typeof_nan
    js_assert_equal("'number'", 'typeof NaN')
  end

  # Infinity

  def test_global_infinity_is_number_positive_infinity
    js_assert_equal('Number.POSITIVE_INFINITY', 'Infinity')
  end

  def test_this_infinity_is_number_positive_infinity
    js_assert_equal('Number.POSITIVE_INFINITY', 'this.Infinity')
  end

  def test_typeof_infinity
    js_assert_equal("'number'", 'typeof Infinity')
  end

  # undefined

  def test_undefined_is_void_0
    js_assert_equal('void 0', 'undefined')
  end
end
