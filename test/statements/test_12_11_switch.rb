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

end
