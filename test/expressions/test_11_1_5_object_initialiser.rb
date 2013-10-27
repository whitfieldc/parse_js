require File.dirname(__FILE__) + "/../helper"

class Expressions_11_1_5_Object_Initialiser_Test < ECMAScriptTestCase

  def test_empty
    @runtime.execute(<<-EOJS)
      var obj = {};
      assert_equal('[object Object]', obj.toString());
    EOJS
  end

  def test_one_property
    @runtime.execute(<<-EOJS)
      var obj = {
        foo: 5
      };
      assert_equal(5, obj.foo);
    EOJS
  end

  def test_multiple_properties
    @runtime.execute(<<-EOJS)
      var obj = {
        foo: 5,
        bar: 6,
        baz: 7
      };
      assert_equal(6, obj.bar);
    EOJS
  end

end
