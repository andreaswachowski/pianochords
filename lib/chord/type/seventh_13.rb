# frozen_string_literal: true

class Chord; end
class Chord::Type; end

class Chord::Type::Seventh13 < Chord::Type
  def self.in_chord_symbol
    '7(13)'
  end

  def self.norm_interval_structure
    # We replace the fifth with the 13
    ['1', '3', '13', 'b7']
  end

  def self.anki_filename
    'seventh_13'
  end

  def self.anki_tag
    'seventh_13'
  end

  def self.html_symbol
    '7(13)'
  end
end
