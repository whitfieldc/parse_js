class ExecuteTestCase < Test::Unit::TestCase
  include RKelly::Nodes

  if method_defined? :default_test
    undef :default_test
  end

  def assert_execute(expected, code)
    env = @runtime.execute(code)
    expected.each do |name, value|
      assert env[name]
      assert_equal value, env[name].value
    end
  end
end
