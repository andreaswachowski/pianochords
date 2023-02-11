# frozen_string_literal: true

require_relative 'chord'
require_relative 'anki_note_writer'

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
    conversion_hash =
      {
        terzlage: '&#9314;',
        quartlage: '&#9315;',
        quintlage: '&#9316;',
        sextlage: '&#9317;',
        septlage: '&#9318;',
        oktavlage: '&#9319;',
        nonlage: '&#9320;',
        thirteenlage: '&#9324;'
      }

    conversion_hash[@chord.akkordlage]
  end

  # protected (could be, but are not for the sake of testability)

  def tags
    "root:#{@chord.root.pitch_name} chordtype:#{@chordtype.anki_tag} lage:#{@chord.akkordlage}"
  end

  def to_html_symbol
    # The diminished chord uses the &deg; entity which is not superscripted.
    modifier = @chordtype.in_chord_symbol == 'o' ? @chordtype.html_symbol : "<sup>#{@chordtype.html_symbol}</sup>"

    "#{AnkiNoteWriter.new(@chord.root).to_html_symbol}#{modifier}&emsp;<sup>#{akkordlage_to_html_symbol}</sup>"
  end

  def importfile_line
    "#{question}\t#{answer}\t#{tags}"
  end

  def akkordlage_for_filename
    conversion_hash =
      {
        terzlage: '3',
        quartlage: '4',
        quintlage: '5',
        sextlage: '6',
        septlage: '7',
        oktavlage: '8',
        nonlage: '9',
        thirteenlage: '13'
      }

    conversion_hash[@chord.akkordlage]
  end
end
