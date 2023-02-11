# frozen_string_literal: true

class Chord; end;
class Chord::Type; end;
class Chord::Type::Seventh < Chord::Type
  def self.in_chord_symbol
    "7"
  end

  def self.norm_interval_structure
    [ "1", "3", "5", "b7" ]
  end

  def self.anki_filename
    "7"
  end

  def self.anki_tag
    "dominantsept"
  end

  def self.html_symbol
    "7"
  end
end
