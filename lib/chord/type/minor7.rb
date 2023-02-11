# frozen_string_literal: true

class Chord; end
class Chord::Type; end
class Chord::Type::Minor7 < Chord::Type
  def self.in_chord_symbol
    '-7'
  end

  def self.norm_interval_structure
    ['1', 'b3', '5', 'b7']
  end

  def self.anki_filename
    'min7'
  end

  def self.anki_tag
    'minor7'
  end

  def self.html_symbol
    '&#8722;7'
  end
end
