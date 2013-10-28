require File.dirname(__FILE__) + "/../helper"

class Expressions_11_4_1_Delete_Test < ECMAScriptTestCase

  def test_delete
    @runtime.execute(<<-EOJS)
      var foo = new Object();
      foo.bar = 1;
      assert_equal(1, foo.bar);
      assert_equal(true, delete foo.bar);
      assert_equal(undefined, foo.bar);
    EOJS
  end

end
