require_relative "../lib/anki_note_writer"
require_relative "test_helper"

class TestAnkiNoteWriter < Test::Unit::TestCase
  def test_to_html_symbol
    assert_equal("A&#9837;",AnkiNoteWriter.new(Note.new("As")).to_html_symbol)
    assert_equal("G&#9839;",AnkiNoteWriter.new(Note.new("Gis")).to_html_symbol)
  end
end
