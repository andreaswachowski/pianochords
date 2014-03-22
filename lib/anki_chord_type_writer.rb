require_relative "chord"
require_relative "chord/type/maj7"

class AnkiChordTypeWriter
  def initialize(chord_type)
    raise ArgumentError.new("Unknown chord type #{chord_type}, must be in #{Chord.chord_types.inspect}") unless Chord.chord_types.include?(chord_type)
    @chord_type = chord_type
  end

  def for_filename
    Chord::Type.create(@chord_type).anki_filename
  end

  def to_tag
    Chord::Type.create(@chord_type).anki_tag
  end

  def html_symbol
    "<sup>#{Chord::Type.create(@chord_type).html_symbol}</sup>"
  end
end
