require File.dirname(__FILE__) + "/../helper"

class Object_15_2_3_1_Prototype_Test < ECMAScriptTestCase
  def test_object_toString
    @runtime.execute(<<-EOJS)
      var obj = new Object();
      assert_equal('function', typeof obj.toString);
      assert_equal('[object Object]', obj.toString());
    EOJS
  end

  def test_object_assign_property
    @runtime.execute(<<-EOJS)
      var obj = new Object();
      obj.foo = 10;
      assert_equal(10, obj.foo);
    EOJS
  end

  def test_object_assign_property_to_prototype_before_creation
    @runtime.execute(<<-EOJS)
      Object.prototype.foo = 10;
      var obj = new Object();
      assert_equal(10, obj.foo);
    EOJS
  end

  def test_object_assign_property_to_prototype_after_creation
    @runtime.execute(<<-EOJS)
      var obj = new Object();
      Object.prototype.foo = 10;
      assert_equal(10, obj.foo);
    EOJS
  end

end
