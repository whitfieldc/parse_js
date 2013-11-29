require File.dirname(__FILE__) + "/../helper"

class Statement_12_12_Labelled_Test < ExecuteTestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_break_out_of_labeled_while_loop
    assert_execute({ 'x' => 4 }, <<-EOJS)
      var x = 0;
      first: while (x < 10) {
          if (x == 4) {
              break first;
          }
          x++;
      }
    EOJS
  end

  def test_break_out_of_two_while_loops
    assert_execute({ 'x' => 4 }, <<-EOJS)
      var x = 0;
      first: while (x < 10) {
          while (x < 5) {
              x++;
              if (x == 4) {
                  break first;
              }
          }
          x++;
      }
    EOJS
  end

  def test_break_out_of_two_labelled_while_loops
    assert_execute({ 'x' => 4 }, <<-EOJS)
      var x = 0;
      first: while (x < 10) {
          second: while (x < 5) {
              x++;
              if (x == 4) {
                  break first;
              }
          }
          x++;
      }
    EOJS
  end

  def test_break_out_of_multitude_of_while_loops
    assert_execute({ 'x' => 4 }, <<-EOJS)
      var x = 0;
      first: while (x < 10) {
          while (true) {
              while (true) {
                  while (true) {
                      x = 4;
                      break first;
                  }
                  x++;
              }
              x++;
          }
          x++;
      }
    EOJS
  end

end
