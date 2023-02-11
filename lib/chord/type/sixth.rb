# frozen_string_literal: true

class Chord; end
class Chord::Type; end
class Chord::Type::Sixth < Chord::Type
  def self.in_chord_symbol
    '6'
  end

  def self.norm_interval_structure
    ['1', '3', '5', '6']
  end

  def self.anki_filename
    '6'
  end

  def self.anki_tag
    'sixth'
  end

  def self.html_symbol
    '6'
  end
end
