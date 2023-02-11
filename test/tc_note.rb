# frozen_string_literal: true

require_relative '../lib/note'
require_relative 'test_helper'

class TestNote < Test::Unit::TestCase
  def test_initialize
    assert_equal('C4', Note.new.scientific_notation)
    assert_equal('C4', Note.new('C').scientific_notation)
    assert_equal(:sharp, Note.new('Cis').accidental)
    assert_equal(:flat, Note.new('Des').accidental)
    assert_equal(49, Note.new('Cis').val)
    assert_equal(49, Note.new('Des').val)

    Note.note_symbols.each do |symbol|
      assert_equal("#{symbol.capitalize}4", Note.new(symbol).scientific_notation)
    end

    [-2, -1, 120, 121].each do |invalid_value|
      assert_raises(ArgumentError) { Note.new(invalid_value) }
    end

    (0..119).each do |valid_value|
      assert_nothing_raised(Exception) { Note.new(valid_value, Note.accidental_required?(valid_value) ? :sharp : nil) }
    end
  end

  def test_equality
    assert_equal(Note.new, Note.new)
  end

  def test_scientific_notation
    (0..9).each do |octave_number|
      assert_equal("C#{octave_number}", Note.new(0+octave_number*12).scientific_notation)
    end
    assert_equal('C4', Note.new(48).scientific_notation)
    assert_equal('Cis4', Note.new(49, :sharp).scientific_notation)
    assert_equal('D4', Note.new(50).scientific_notation)
  end

  def test_pitch_name
    assert_equal('Cis', Note.new(49, :sharp).pitch_name)
    assert_equal('Cis', Note.new('Cis').pitch_name)
    assert_equal('Des', Note.new('Des').pitch_name)
  end

  def test_offset
    assert_equal(0, Note.offset('bis'))
    assert_equal(0, Note.offset('C'))
    assert_equal(1, Note.offset('Cis'))
    assert_equal(1, Note.offset('des'))
    assert_equal(2, Note.offset('d'))
    assert_equal(3, Note.offset('dis'))
    assert_equal(3, Note.offset('es'))
    assert_equal(4, Note.offset('e'))
    assert_equal(4, Note.offset('fes'))
    assert_equal(5, Note.offset('eis'))
    assert_equal(5, Note.offset('f'))
    assert_equal(6, Note.offset('ges'))
    assert_equal(6, Note.offset('fis'))
    assert_equal(7, Note.offset('g'))
    assert_equal(8, Note.offset('gis'))
    assert_equal(8, Note.offset('as'))
    assert_equal(9, Note.offset('a'))
    assert_equal(10, Note.offset('ais'))
    assert_equal(10, Note.offset('bes'))
    assert_equal(11, Note.offset('b'))
    assert_equal(11, Note.offset('ces'))
  end

  def test_adding_intervals
    assert_equal(Note.new(48), Note.new(48) + Interval.new('1'))
    assert_equal(Note.new(50), Note.new(48) + Interval.new('2'))
    assert_equal(Note.new(42, :sharp), Note.new(48) - Interval.new('#4'))
    assert_equal(Note.new(60), Note.new(48) + Interval.new('8'))
  end
end
