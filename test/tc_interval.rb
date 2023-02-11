# frozen_string_literal: true

require_relative '../lib/interval'
require_relative 'test_helper'

class TestInterval < Test::Unit::TestCase
  def test_initialize
    assert_equal('b2 up', Interval.new('b2').to_s)
    assert_equal('4 up', Interval.new('4', :up).to_s)
    assert_equal('6 down', Interval.new('6', :down).to_s)
    assert_raises(ArgumentError) { Interval.new('b0') }
    assert_raises(ArgumentError) { Interval.new('b2', :invalid_direction) }
  end

  def test_half_steps
    assert_equal(6, Interval.new('#4').half_steps)
    assert_equal(-6, Interval.new('#4', :down).half_steps)
  end

  def test_comparison
    assert(Interval.new('3') < Interval.new('#4'))
    assert(Interval.new('#5') > Interval.new('#4'))
    assert(Interval.new('b7') > Interval.new('b2'))
    assert(Interval.new('b7') > Interval.new('2'))
    # Make sure directions are ignored:
    assert(Interval.new('7', :up) < Interval.new('8', :down))
    # What about equality?
    assert(Interval.new('#4') == Interval.new('b5'))
    assert(Interval.new('b3') == Interval.new('#2'))
  end

  def test_comparison_advanced
    unsorted = ['b5', '3', '6', '7', 'b2'].map { |i| Interval.new(i) }
    sorted = ['b2', '3', 'b5', '6', '7'].map { |i| Interval.new(i) }
    assert_equal(unsorted.sort, sorted)
  end

  def test_negation
    assert_equal(-6, (-Interval.new('#4')).half_steps)
    assert_equal(6, (-Interval.new('#4', :down)).half_steps)
  end
end

