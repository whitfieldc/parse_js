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

  def test_delete_in_obj
    assert_equal true, @obj.delete("foo")
    assert_equal :undefined, @obj["foo"]
  end

  def test_delete_in_prototype_reflects_in_obj
    assert_equal true, @proto.delete("bar")
    assert_equal :undefined, @obj["bar"]
  end

  def test_delete_in_obj_does_not_effect_prototype
    assert_equal true, @obj.delete("bar")
    assert_equal 42, @obj["bar"]
  end

  def test_delete_unconfigurable_property
    @obj.define_own_property("own", {:value => 7, :configurable => false})
    assert_equal false, @obj.delete("own")
    assert_equal 7, @obj["own"]
  end

  def test_delete_explicitly_configurable_property
    @obj.define_own_property("own", {:value => 7, :configurable => true})
    assert_equal true, @obj.delete("own")
    assert_equal :undefined, @obj["own"]
  end

  def test_delete_by_default_on_property_created_with_define_own_property
    @obj.define_own_property("own", {:value => 7})
    assert_equal true, @obj.delete("own")
    assert_equal :undefined, @obj["own"]
  end

  def test_define_own_property_sets_value
    @obj.define_own_property("own", {:value => 10})
    assert_equal 10, @obj["own"]
  end

  def test_can_put_by_default_on_missing_property
    assert_equal true, @obj.can_put?("blah")
  end

  def test_can_put_by_default_on_existing_property
    assert_equal true, @obj.can_put?("foo")
  end

  def test_can_put_on_explicitly_unwritable_property
    @obj.define_own_property("own", {:value => 7, :writable => false})
    assert_equal false, @obj.can_put?("own")
  end

  def test_can_put_on_explicitly_writable_property
    @obj.define_own_property("own", {:value => 7, :writable => true})
    assert_equal true, @obj.can_put?("own")
  end

  def test_can_put_by_default_on_property_defined_with_define_own_property
    @obj.define_own_property("own", {:value => 7})
    assert_equal true, @obj.can_put?("own")
  end

  def test_setting_value_of_readonly_property
    @obj.define_own_property("own", {:value => 7, :writable => false})
    @obj["own"] = 5
    assert_equal 7, @obj["own"]
  end

  def test_enumerable_keys_returns_keys_in_object_itself
    assert @obj.enumerable_keys.include?("foo")
  end

  def test_enumerable_keys_returns_keys_in_object_prototype
    assert @obj.enumerable_keys.include?("bar")
  end

  def test_enumerable_keys_does_not_return_nonenumerable_keys
    @obj.define_own_property("own", {:value => 7, :enumerable => false})
    assert_equal false, @obj.enumerable_keys.include?("own")
  end

  def test_enumerable_keys_does_not_return_duplicate_keys
    @obj["bar"] = 11
    assert_equal 1, @obj.enumerable_keys.find_all {|k| k == "bar" }.length
  end

end
