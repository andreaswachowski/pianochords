# frozen_string_literal: true

class Chord; end;
class Chord::Type; end;
class Chord::Type::Ninth < Chord::Type
  def self.in_chord_symbol
    "9"
  end

  def self.norm_interval_structure
    # We replace the root with the 9
    [ "2", "3", "5", "b7" ]
  end

  def self.anki_filename
    "9"
  end

  def self.anki_tag
    "ninth"
  end

  def self.html_symbol
    "9"
  end
end
