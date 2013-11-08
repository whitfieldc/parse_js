require File.dirname(__FILE__) + "/../helper"

class Statement_12_11_Switch_Test < ExecuteTestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_first_case_matches
    assert_execute({ 'x' => 'A' }, <<-EOJS)
      var x;
      switch (1) {
        case 1: x = 'A'; break;
        case 2: x = 'B'; break;
        default: x = 'C';
      }
    EOJS
  end

  def test_second_case_matches
    assert_execute({ 'x' => 'B' }, <<-EOJS)
      var x;
      switch (2) {
        case 1: x = 'A'; break;
        case 2: x = 'B'; break;
        default: x = 'C';
      }
    EOJS
  end

  def test_default_case_matches
    assert_execute({ 'x' => 'C' }, <<-EOJS)
      var x;
      switch (3) {
        case 1: x = 'A'; break;
        case 2: x = 'B'; break;
        default: x = 'C';
      }
    EOJS
  end

  def test_fall_through_first_case
    assert_execute({ 'x' => 3 }, <<-EOJS)
      var x = 0;
      switch (1) {
        case 1: x += 1;
        case 2: x += 2; break;
        default: x += 4;
      }
    EOJS
  end

  def test_fall_through_all_cases
    assert_execute({ 'x' => 7 }, <<-EOJS)
      var x = 0;
      switch (1) {
        case 1: x += 1;
        case 2: x += 2;
        default: x += 4;
      }
    EOJS
  end

  def test_fall_through_default_case_and_all_others
    assert_execute({ 'x' => 7 }, <<-EOJS)
      var x = 0;
      switch (2) {
        default: x += 1;
        case 1: x += 2;
        case 2: x += 4;
      }
    EOJS
  end

end
