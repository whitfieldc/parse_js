require File.dirname(__FILE__) + "/helper"

class GlobalObjectTest < Test::Unit::TestCase

  def setup
    @object = RKelly::JS::GlobalObject.new
  end

  def test_initialize
    assert_equal nil, @object.prototype
    assert_equal 'GlobalObject', @object.class_name
  end

end
