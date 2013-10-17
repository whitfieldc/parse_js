require File.dirname(__FILE__) + "/helper"

class TestLexicalEnvironment < Test::Unit::TestCase
  def setup
    env_0 = RKelly::JS::LexicalEnvironment.new_global_environment

    env_1 = env_0.new_declarative_environment
    env_1.record[:foo] = 1

    env_2 = env_1.new_declarative_environment
    env_2.record[:bar] = 10

    @env = env_2.new_declarative_environment
  end

  def test_global_object_in_chain
    assert @env['NaN']
  end

  def test_access_bindings
    assert_equal(1, @env[:foo])
    assert_equal(10, @env[:bar])
    assert !@env[:baz]
    assert @env.outer[:bar]
    assert !@env.outer.outer[:bar]
  end

  def test_add_binding
    assert !@env[:baz]
    @env.record[:baz] = 10
    assert @env[:baz]
    assert !@env.outer[:baz]
  end

end
