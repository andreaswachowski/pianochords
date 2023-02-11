# frozen_string_literal: true

class Chord; end;
class Chord::Type; end;
class Chord::Type::AugMaj7 < Chord::Type
  def self.in_chord_symbol
    "+maj7"
  end

  def self.norm_interval_structure
    [ "1", "3", "#5", "7" ]
  end

  def self.anki_filename
    "augmaj7"
  end

  def self.anki_tag
    "augmaj7"
  end

  def self.html_symbol
    "+maj7"
  end
end
