# frozen_string_literal: true

class Chord; end
class Chord::Type; end
class Chord::Type::MinorMaj7 < Chord::Type
  def self.in_chord_symbol
    '-maj7'
  end

  def self.norm_interval_structure
    ['1', 'b3', '5', '7']
  end

  def self.anki_filename
    'minmaj7'
  end

  def self.anki_tag
    'minormaj7'
  end

  def self.html_symbol
    '&#8722;maj7'
  end
end
