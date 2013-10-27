require File.dirname(__FILE__) + "/helper"

class JsBaseTest < Test::Unit::TestCase
  include RKelly::JS

  def setup
    @obj = Base.new
    @obj["foo"] = 10
    @proto = Base.new
    @proto["bar"] = 42
    @obj.prototype = @proto
  end

  def test_get_missing_key
    assert_equal :undefined, @obj["blah"]
  end

  def test_get_existing_key
    assert_equal 10, @obj["foo"]
  end

  def test_get_key_in_prototype
    assert_equal 42, @obj["bar"]
  end

  def test_has_property_with_missing
    assert_equal false, @obj.has_property?("blah")
  end

  def test_has_property_with_property_in_current_obj
    assert_equal true, @obj.has_property?("foo")
  end

  def test_has_property_with_property_in_prototype
    assert_equal true, @obj.has_property?("bar")
  end

  def test_change_in_prototype_reflects_in_current_obj
    @proto["baz"] = true
    assert_equal true, @obj["baz"]
  end
end
