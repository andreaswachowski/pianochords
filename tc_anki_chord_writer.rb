require_relative "anki_chord_writer"
require "test/unit"

class TestAnkiChordWriter < Test::Unit::TestCase
  def test_question
    a = AnkiChordWriter.new(Chord.new)
    assert_equal("C<sup>maj7</sup>&emsp;<sup>#{a.akkordlage_to_html_symbol}</sup>",a.question)
  end

  def test_to_html_symbol
    assert_equal("C<sup>maj7</sup>&emsp;<sup>&#9318;</sup>",AnkiChordWriter.new(Chord.new).to_html_symbol)
    assert_equal("A&#9837;<sup>o7</sup>&emsp;<sup>&#9319;</sup>",AnkiChordWriter.new(Chord.new("As",:dim7,:first)).to_html_symbol)
    assert_equal("G&#9839;<sup>o7</sup>&emsp;<sup>&#9316;</sup>",AnkiChordWriter.new(Chord.new("Gis",:dim7,:third)).to_html_symbol)
  end

  def test_answer
    assert_equal("<img src=\"pianochord_Es_maj7_7.png\">",AnkiChordWriter.new(Chord.new("Es",:maj7,:root)).answer)
    assert_equal("<img src=\"pianochord_Ais_min7_7.png\">",AnkiChordWriter.new(Chord.new("Ais",:minor7,:root)).answer)
    assert_equal("<img src=\"pianochord_B_dim7_5.png\">",AnkiChordWriter.new(Chord.new("B",:dim7,:third)).answer)
  end

  def test_akkordlage_to_html_symbol
    assert_equal("&#9318;",AnkiChordWriter.new(Chord.new("C",:maj7,:root)).akkordlage_to_html_symbol)
    assert_equal("&#9319;",AnkiChordWriter.new(Chord.new("C",:maj7,:first)).akkordlage_to_html_symbol)
    assert_equal("&#9314;",AnkiChordWriter.new(Chord.new("C",:maj7,:second)).akkordlage_to_html_symbol)
    assert_equal("&#9316;",AnkiChordWriter.new(Chord.new("C",:maj7,:third)).akkordlage_to_html_symbol)
  end

  def test_tags
    assert_equal("root:C chordtype:maj7 lage:terzlage",AnkiChordWriter.new(Chord.new("C",:maj7,:second)).tags)
  end

  def test_importfile_line
    c = Chord.new
    a = AnkiChordWriter.new(c)
    assert_equal("#{a.question}\t#{a.answer}\t#{a.tags}",a.importfile_line)
  end
end
