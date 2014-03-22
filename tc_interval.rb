require_relative "interval"
require "test/unit"

class TestInterval < Test::Unit::TestCase
  def test_initialize
    assert_equal("b2 up",Interval.new("b2").to_s)
    assert_equal("4 up",Interval.new("4",:up).to_s)
    assert_equal("6 down",Interval.new("6",:down).to_s)
    assert_raises(ArgumentError) { Interval.new("b0"); }
    assert_raises(ArgumentError) { Interval.new("b2",:invalid_direction); }
  end

  def test_half_steps
    assert_equal(6,Interval.new("#4").half_steps)
    assert_equal(-6,Interval.new("#4",:down).half_steps)
  end

  def test_negation
    assert_equal(-6,(-Interval.new("#4")).half_steps)
    assert_equal(6,(-Interval.new("#4",:down)).half_steps)
  end
end

