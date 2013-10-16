require File.dirname(__FILE__) + "/../helper"

class Statement_12_6_3_For_Test < ExecuteTestCase
  def setup
    @runtime = RKelly::Runtime.new
  end

  def test_for_with_var
    assert_execute({ 'i' => 10 }, <<-EOJS)
      for (var i=0; i<10; i++) {
      }
    EOJS
  end

  def test_for_without_var
    assert_execute({ 'i' => 10 }, <<-EOJS)
      var i;
      for (i=0; i<10; i++) {
      }
    EOJS
  end

  def test_for_without_initializer
    assert_execute({ 'i' => 10 }, <<-EOJS)
      var i=0;
      for (; i<10; i++) {
      }
    EOJS
  end

  def test_for_without_condition
    assert_execute({ 'i' => 10 }, <<-EOJS)
      for (var i=0; ; i++) {
        if (i == 10) return;
      }
    EOJS
  end

  def test_for_without_counter
    assert_execute({ 'i' => 10 }, <<-EOJS)
      for (var i=0; i<10; ) {
        i++;
      }
    EOJS
  end

  def test_empty_for
    assert_execute({ 'i' => 10 }, <<-EOJS)
      var i=0;
      for ( ; ; ) {
        if (i==10) return;
        i++;
      }
    EOJS
  end

end
