require File.dirname(__FILE__) + "/../helper"

class Expressions_11_8_Relational_Test < ExecuteTestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  @@tests = [
    "1 < 2" => true,
    "2 < 1" => false,
    "2 < 2" => false,
    "NaN < 1" => false,
    "1 < NaN" => false,
    "NaN < NaN" => false,
    "+Infinity < 1" => false,
    "-Infinity < 1" => true,
    "1 < +Infinity" => true,
    "1 < -Infinity" => false,
    "+Infinity < +Infinity" => false,
    "+Infinity < -Infinity" => false,
    "-Infinity < +Infinity" => true,
    "-Infinity < -Infinity" => false,
    "'abc' < 'a'" => false,
    "'a' < 'abc'" => true,
    "'ab' < 'ac'" => true,
    "'ac' < 'ab'" => false,
    "'abc' < 'abc'" => false,

    "1 > 2" => false,
    "2 > 1" => true,
    "2 > 2" => false,
    "NaN > 1" => false,
    "1 > NaN" => false,
    "NaN > NaN" => false,
    "+Infinity > 1" => true,
    "-Infinity > 1" => false,
    "1 > +Infinity" => false,
    "1 > -Infinity" => true,
    "+Infinity > +Infinity" => false,
    "+Infinity > -Infinity" => true,
    "-Infinity > +Infinity" => false,
    "-Infinity > -Infinity" => false,
    "'abc' > 'a'" => true,
    "'a' > 'abc'" => false,
    "'ab' > 'ac'" => false,
    "'ac' > 'ab'" => true,
    "'abc' > 'abc'" => false,

    "1 <= 2" => true,
    "2 <= 1" => false,
    "2 <= 2" => true,
    "NaN <= 1" => false,
    "1 <= NaN" => false,
    "NaN <= NaN" => false,
    "+Infinity <= 1" => false,
    "-Infinity <= 1" => true,
    "1 <= +Infinity" => true,
    "1 <= -Infinity" => false,
    "+Infinity <= +Infinity" => true,
    "+Infinity <= -Infinity" => false,
    "-Infinity <= +Infinity" => true,
    "-Infinity <= -Infinity" => true,
    "'abc' <= 'a'" => false,
    "'a' <= 'abc'" => true,
    "'ab' <= 'ac'" => true,
    "'ac' <= 'ab'" => false,
    "'abc' <= 'abc'" => true,

    "1 >= 2" => false,
    "2 >= 1" => true,
    "2 >= 2" => true,
    "NaN >= 1" => false,
    "1 >= NaN" => false,
    "NaN >= NaN" => false,
    "+Infinity >= 1" => true,
    "-Infinity >= 1" => false,
    "1 >= +Infinity" => false,
    "1 >= -Infinity" => true,
    "+Infinity >= +Infinity" => true,
    "+Infinity >= -Infinity" => true,
    "-Infinity >= +Infinity" => false,
    "-Infinity >= -Infinity" => true,
    "'abc' >= 'a'" => true,
    "'a' >= 'abc'" => false,
    "'ab' >= 'ac'" => false,
    "'ac' >= 'ab'" => true,
    "'abc' >= 'abc'" => true,
  ]

  @@tests.each do |testing|
    testing.each do |expression, expected|
      define_method(:"test_#{expression.gsub(/ /, '_')}") do
        assert_execute({'x' => expected}, "var x = #{expression};")
      end
    end
  end

end
