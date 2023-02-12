# frozen_string_literal: true

require_relative '../lib/anki_chord_writer'
require_relative 'test_helper'

class TestAnkiChordWriter < Test::Unit::TestCase
  def test_question
    a = AnkiChordWriter.new(Chord.new)
    assert_equal("C<sup>maj7</sup>&emsp;<sup>#{a.akkordlage_to_html_symbol}</sup>", a.question)
  end

  def written_chord(root, chord_type, inversion)
    AnkiChordWriter.new(Chord.new(root, chord_type, inversion))
  end

  def html_chord_symbol(root, chord_type, inversion)
    written_chord(root, chord_type, inversion).to_html_symbol
  end

  def answer(root, chord_type, inversion)
    written_chord(root, chord_type, inversion).answer
  end

  def akkordlage_symbol(root, chord_type, inversion)
    written_chord(root, chord_type, inversion).akkordlage_to_html_symbol
  end

  def test_to_html_symbol
    assert_equal('C<sup>maj7</sup>&emsp;<sup>&#9318;</sup>', AnkiChordWriter.new(Chord.new).to_html_symbol)
    assert_equal('A&#9837;&deg;&emsp;<sup>&#9319;</sup>', html_chord_symbol('As', :dim7, :first))
    assert_equal('G&#9839;&deg;&emsp;<sup>&#9316;</sup>', html_chord_symbol('Gis', :dim7, :third))
  end

  def test_answer
    assert_equal('<img src="pianochord_Es_maj7_7.png">', answer('Es', :maj7, :root))
    assert_equal('<img src="pianochord_Ais_min7_7.png">', answer('Ais', :minor7, :root))
    assert_equal('<img src="pianochord_B_dim7_5.png">', answer('B', :dim7, :third))
  end

  def test_akkordlage_to_html_symbol
    assert_equal('&#9318;', akkordlage_symbol('C', :maj7, :root))
    assert_equal('&#9319;', akkordlage_symbol('C', :maj7, :first))
    assert_equal('&#9314;', akkordlage_symbol('C', :maj7, :second))
    assert_equal('&#9316;', akkordlage_symbol('C', :maj7, :third))
  end

  def test_tags
    assert_equal('root:C chordtype:maj7 lage:terzlage', written_chord('C', :maj7, :second).tags)
  end

  def test_importfile_line
    c = Chord.new
    a = AnkiChordWriter.new(c)
    assert_equal("#{a.question}\t#{a.answer}\t#{a.tags}", a.importfile_line)
  end
end
