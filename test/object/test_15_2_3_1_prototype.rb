require File.dirname(__FILE__) + "/../helper"

class Object_15_2_3_1_Prototype_Test < ECMAScriptTestCase
  def test_object_toString
    @runtime.execute(<<-EOJS)
      var obj = new Object();
      assert_equal('function', typeof obj.toString);
      assert_equal('[object Object]', obj.toString());
    EOJS
  end

end
