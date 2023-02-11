# frozen_string_literal: true

class Chord; end;
class Chord::Type; end;
class Chord::Type::Sus4 < Chord::Type
  def self.in_chord_symbol
    'sus4'
  end

  def self.norm_interval_structure
    ['1', '4', '5', 'b7']
  end

  def self.anki_filename
    '7sus4'
  end

  def self.anki_tag
    '7sus4'
  end

  def self.html_symbol
    '7sus4'
  end
end
