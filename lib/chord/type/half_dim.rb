# frozen_string_literal: true

class Chord; end;
class Chord::Type; end;
class Chord::Type::HalfDim < Chord::Type
  def self.in_chord_symbol
    '-7(b5)'
  end

  def self.norm_interval_structure
    ['1', 'b3', 'b5', 'b7']
  end

  def self.anki_filename
    'b7b5'
  end

  def self.anki_tag
    'halbvermindert'
  end

  def self.html_symbol
    '-7(&#9837;5)'
  end
end
