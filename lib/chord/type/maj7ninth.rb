class Chord; end;
class Chord::Type; end;
class Chord::Type::Maj7Ninth < Chord::Type
  def self.in_chord_symbol
    "maj7_9"
  end

  def self.norm_interval_structure
    # We replace the root with the 9
    [ "2", "3", "5", "7" ]
  end

  def self.anki_filename
    "maj7_9"
  end

  def self.anki_tag
    "maj7_9"
  end

  def self.html_symbol
    "maj7_9"
  end
end
