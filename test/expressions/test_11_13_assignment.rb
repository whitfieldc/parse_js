require File.dirname(__FILE__) + "/../helper"

class Expressions_11_13_Assignment_Test < ExecuteTestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_simple_assignment
    assert_execute({ 'x' => 2 }, <<-EOJS)
      var x = 1;
      x = 2;
    EOJS
  end

  tests = [
    [:plus_equal,     'var x = 10; x += 2;', 12],
    [:minus_equal,    'var x = 10; x -= 2;', 8],
    [:multiply_equal, 'var x = 10; x *= 2;', 20],
    [:divide_equal,   'var x = 10; x /= 2;', 5],
    [:mod_equal,      'var x = 10; x %= 3;', 1],
    # bitwise
    [:and_equal,      'var x = 7;  x &= 5;', 5],
    [:or_equal,       'var x = 7;  x |= 5;', 7],
    [:xor_equal,      'var x = 10; x ^= 8;', 2],
    # bitwise shift
    [:left_shift,           'var x = -10; x <<= 2;', -40],
    [:signed_right_shift,   'var x = -40; x >>= 2;', -10],
    # Disabled:
    # Ruby doesn't have built-in >>> operator,
    # so we need a custom implementation of our own.
    # [:unsigned_right_shift, 'var x = -40; x >>>= 2;', 1073741814],
  ]

  tests.each do |name, expression, expected|
    define_method(:"test_#{name}") do
      assert_execute({ 'x' => expected }, expression)
    end
  end

end
