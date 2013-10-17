require File.dirname(__FILE__) + "/../helper"

class ExecutionContext_10_1_3_1_Test < Test::Unit::TestCase
  def setup
    @runtime = RKelly::Runtime.new
    @runtime.define_function(:assert_equal) do |*args|
      assert_equal(*args)
    end
  end

  def test_myfun3_void_0
    env = @runtime.execute(<<-EOJS)
        function myfun3(a, b, a) {
            return a;
        }
        var x = myfun3(2,4);
    EOJS
    assert env['x']
    #assert_equal :undefined, scope_chain['x'].value
  end

  def test_myfun3
    env = @runtime.execute(<<-EOJS)
        function myfun3(a, b, a) {
            return a;
        }
        var x = myfun3(2,4,8);
    EOJS
    assert env['x']
    assert_equal 8, env['x'].value
  end
end
