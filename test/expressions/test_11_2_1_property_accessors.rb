require File.dirname(__FILE__) + "/../helper"

class Expressions_11_2_1_Property_Accessors_Test < ECMAScriptTestCase

  def test_set_dot_get_dot
    @runtime.execute(<<-EOJS)
      var obj = new Object();
      obj.foo = 10;
      assert_equal(10, obj.foo);
    EOJS
  end

  def test_set_dot_get_bracket
    @runtime.execute(<<-EOJS)
      var obj = new Object();
      obj.foo = 10;
      assert_equal(10, obj["foo"]);
    EOJS
  end

  def test_set_bracket_get_dot
    @runtime.execute(<<-EOJS)
      var obj = new Object();
      obj["foo"] = 10;
      assert_equal(10, obj.foo);
    EOJS
  end

  def test_set_bracket_get_bracket
    @runtime.execute(<<-EOJS)
      var obj = new Object();
      obj["foo"] = 10;
      assert_equal(10, obj["foo"]);
    EOJS
  end

  def test_bracket_with_more_complex_expression
    @runtime.execute(<<-EOJS)
      var obj = new Object();
      obj["f"+"oo"] = 10;
      assert_equal(10, obj["fo"+"o"]);
    EOJS
  end

end
