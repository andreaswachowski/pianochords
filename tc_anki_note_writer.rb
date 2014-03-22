require_relative "anki_note_writer"
require "test/unit"

class TestAnkiNoteWriter < Test::Unit::TestCase
  def test_to_html_symbol
    assert_equal("A&#9837;",AnkiNoteWriter.new(Note.new("As")).to_html_symbol)
    assert_equal("G&#9839;",AnkiNoteWriter.new(Note.new("Gis")).to_html_symbol)
  end
end
