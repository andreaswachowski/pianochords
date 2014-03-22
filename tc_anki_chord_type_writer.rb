require_relative "anki_chord_type_writer"
require "test/unit"

class TestAnkiChordTypeWriter < Test::Unit::TestCase
  def test_to_tag
    assert_equal("maj7",AnkiChordTypeWriter.new(:maj7).to_tag)
    assert_equal("dominantsept",AnkiChordTypeWriter.new(:seventh).to_tag)
    assert_equal("moll7",AnkiChordTypeWriter.new(:minor7).to_tag)
    assert_equal("halbvermindert",AnkiChordTypeWriter.new(:halfdim).to_tag)
    assert_equal("vermindert",AnkiChordTypeWriter.new(:dim7).to_tag)

    # Make sure we don't miss to add functionality when new chord types are introduced
    assert_equal(5,Chord.chord_types.size)
  end

  def test_html_symbol
    assert_equal("<sup>maj7</sup>",AnkiChordTypeWriter.new(:maj7).html_symbol)
    assert_equal("<sup>7</sup>",AnkiChordTypeWriter.new(:seventh).html_symbol)
    assert_equal("<sup>-7</sup>",AnkiChordTypeWriter.new(:minor7).html_symbol)
    assert_equal("<sup>-7(&#9837;5)</sup>",AnkiChordTypeWriter.new(:halfdim).html_symbol)
    assert_equal("<sup>o7</sup>",AnkiChordTypeWriter.new(:dim7).html_symbol)
  end


end
