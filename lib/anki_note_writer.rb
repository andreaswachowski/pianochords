# frozen_string_literal: true

require_relative 'note'

class AnkiNoteWriter
  def initialize(note)
    @note = note
  end

  def to_html_symbol
    name = @note.pitch_name[0]
    unless @note.accidental.nil?
      name += @note.accidental == :sharp ? '&#9839;' : '&#9837;'
    end
    name
  end
end
