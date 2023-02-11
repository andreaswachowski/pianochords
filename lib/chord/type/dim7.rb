# frozen_string_literal: true

class Chord; end
class Chord::Type; end

class Chord::Type::Dim7 < Chord::Type
  def self.in_chord_symbol
    'o'
  end

  def self.norm_interval_structure
    %w[1 b3 b5 6]
  end

  def self.anki_filename
    'dim7'
  end

  def self.anki_tag
    'vermindert'
  end

  def self.html_symbol
    '&deg;'
  end
end
