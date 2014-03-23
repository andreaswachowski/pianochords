require_relative "../lib/chord"
require_relative "note_test_helper"
require_relative "test_helper"

class TestChord < Test::Unit::TestCase
  def test_initialize
    c = Chord.new
    assert_equal(Note.new(48),c.root)
    assert_equal(:maj7,c.chord_type)
    assert_equal(:root,c.inversion)

    c = Chord.new("Gis",:dim7,:third)
    assert_equal("Gis",c.root.pitch_name)

    assert_raises(ArgumentError) { Chord.new(Note.new(48),:invalid_chord_type); }
    assert_raises(ArgumentError) { Chord.new(Note.new(48),:maj7,:invalid_inversion); }

    # A simple triad does not have a third inversion
    assert_raises(ArgumentError) { Chord.new("C",:aug,:third) }

    # TODO Make Chord constructor more flexible, and permit the below
    # c = Chord.new(:inversion => :first)
    # assert_equal(Note.new,c.root)
    # assert_equal(:maj7,c.chord_type)
    # assert_equal(:first,c.inversion)

    # c = Chord.new(:akkordlage => :oktavlage)
    # assert_equal(Note.new,c.root)
    # assert_equal(:maj7,c.chord_type)
    # assert_equal(:oktavlage,c.akkordlage)
  end

  def test_akkordlage
    # seventh chord with 4 tones
    assert_equal(:septlage, Chord.new(Note.new(48),:maj7).akkordlage)
    assert_equal(:septlage, Chord.new(Note.new(48),:maj7, :root).akkordlage)
    assert_equal(:oktavlage,Chord.new(Note.new(48),:maj7, :first).akkordlage)
    assert_equal(:terzlage,Chord.new(Note.new(48),:maj7, :second).akkordlage)
    assert_equal(:quintlage,Chord.new(Note.new(48),:maj7, :third).akkordlage)

    # Triad, 3 tones
    assert_raises(ArgumentError) { Chord.new(Note.new(48),:aug, :third) }
    assert_equal(:quintlage,Chord.new(Note.new(48),:aug, :root).akkordlage)
    assert_equal(:oktavlage,Chord.new(Note.new(48),:aug, :first).akkordlage)
    assert_equal(:terzlage,Chord.new(Note.new(48),:aug, :second).akkordlage)
  end

  def test_inversions
    [ :maj7, :seventh, :minor7, :halfdim, :dim7 ].each do |t|
      assert_equal([ :root, :first, :second, :third ],Chord.new(Note.new,t).inversions)
    end
    [ :aug ].each do |t|
    assert_equal([ :root, :first, :second ],Chord.new(Note.new,t).inversions)
    end
  end

  def test_interval_structure
    assert_equal([ "1", "3", "#5" ],Chord.new(Note.new,:aug,:root).interval_structure)
    assert_equal([ "1", "3", "5", "7" ],Chord.new(Note.new,:maj7,:root).interval_structure)
    assert_equal([ "3", "5", "b7", "1" ],Chord.new(Note.new,:seventh,:first).interval_structure)
    assert_equal([ "5", "b7", "1", "b3" ],Chord.new(Note.new,:minor7,:second).interval_structure)
    assert_equal([ "b7", "1", "b3", "b5" ],Chord.new(Note.new,:halfdim,:third).interval_structure)
    assert_equal([ "6", "1", "b3", "b5" ],Chord.new(Note.new,:dim7,:third).interval_structure)
  end

  def test_notes
    # All chord types in root position
    assert_equal([ 48, 52, 55, 59 ].map { |x| NoteTestHelper.new_note(x) },Chord.new(Note.new,:maj7,:root).notes)
    assert_equal([ 48, 52, 55, 58 ].map { |x| NoteTestHelper.new_note(x) },Chord.new(Note.new,:seventh,:root).notes)
    assert_equal([ 48, 51, 55, 58 ].map { |x| NoteTestHelper.new_note(x) },Chord.new(Note.new,:minor7,:root).notes)
    assert_equal([ 48, 51, 54, 57 ].map { |x| NoteTestHelper.new_note(x) },Chord.new(Note.new,:dim7,:root).notes)
    assert_equal([ 48, 51, 54, 58 ].map { |x| NoteTestHelper.new_note(x) },Chord.new(Note.new,:halfdim,:root).notes)
    assert_equal([ 48, 52, 56 ].map { |x| NoteTestHelper.new_note(x) },Chord.new(Note.new,:aug,:root).notes)

    # Inversions (notice some notes must be below the root, i.e., an octave (12 halftones) lower)
    assert_equal([ 48, 52, 55, 59 ].map { |x| NoteTestHelper.new_note(x) },Chord.new(Note.new,:maj7,:root).notes)
    assert_equal([ 40, 43, 47, 48 ].map { |x| NoteTestHelper.new_note(x) },Chord.new(Note.new,:maj7,:first).notes)
    assert_equal([ 43, 47, 48, 52 ].map { |x| NoteTestHelper.new_note(x) },Chord.new(Note.new,:maj7,:second).notes)
    assert_equal([ 47, 48, 52, 55 ].map { |x| NoteTestHelper.new_note(x) },Chord.new(Note.new,:maj7,:third).notes)
    assert_equal([ 40, 44, 48 ].map { |x| NoteTestHelper.new_note(x) },Chord.new(Note.new,:aug,:first).notes)

    # Mixed
    assert_equal([ 40, 43, 46, 48 ].map { |x| NoteTestHelper.new_note(x) },Chord.new(Note.new,:seventh,:first).notes)
    assert_equal([ 43, 46, 48, 51 ].map { |x| NoteTestHelper.new_note(x) },Chord.new(Note.new,:minor7,:second).notes)
    assert_equal([ 46, 48, 51, 54 ].map { |x| NoteTestHelper.new_note(x) },Chord.new(Note.new,:halfdim,:third).notes)
  end

  def test_to_symbol
    assert_equal("Cmaj7 (7)",Chord.new.to_symbol)
    assert_equal("C7 (7)",Chord.new("C",:seventh).to_symbol)
    assert_equal("C-7 (8)",Chord.new("C",:minor7,:first).to_symbol)
    assert_equal("Co7 (3)",Chord.new("C",:dim7,:second).to_symbol)
    assert_equal("C-7(b5) (5)",Chord.new("C",:halfdim,:third).to_symbol)
  end

end
