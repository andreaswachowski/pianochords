require_relative "chord"
require_relative "anki_note_writer"

class AnkiChordWriter
  def initialize(chord)
    @chord = chord
    @chordtype = Chord::Type.create(@chord.chord_type)
  end

  # Generate a textual representation of the chord name
  # suitable for the Anki question
  def question
    to_html_symbol
  end

  def filename
    "pianochord_#{@chord.root.pitch_name}_#{@chordtype.anki_filename}_#{akkordlage_for_filename}.png"
  end

  def answer
    "<img src=\"#{filename}\">"
  end

  # We use encircled numbers to signify the akkordlage
  def akkordlage_to_html_symbol
    case @chord.akkordlage
    when :septlage
      "&#9318;"
    when :oktavlage
      "&#9319;"
    when :terzlage
      "&#9314;"
    when :quintlage
      "&#9316;"
    end
  end

  # protected (could be, but are not for the sake of testability)

  def tags
    "root:#{@chord.root.pitch_name} chordtype:#{@chordtype.anki_tag} lage:#{@chord.akkordlage}"
  end

  def to_html_symbol
    "#{AnkiNoteWriter.new(@chord.root).to_html_symbol}<sup>#{@chordtype.html_symbol}</sup>&emsp;<sup>#{akkordlage_to_html_symbol}</sup>"
  end

  def importfile_line
    "#{question}\t#{answer}\t#{tags}"
  end

  def akkordlage_for_filename
    case @chord.akkordlage
    when :septlage
      "7"
    when :oktavlage
      "8"
    when :terzlage
      "3"
    when :quintlage
      "5"
    end
  end
end
