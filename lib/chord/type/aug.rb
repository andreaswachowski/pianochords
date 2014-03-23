class Chord; end;
class Chord::Type; end;
class Chord::Type::Aug < Chord::Type
  def self.in_chord_symbol
    "+"
  end

  def self.norm_interval_structure
    [ "1", "3", "#5" ]
  end

  def self.anki_filename
    "aug"
  end

  def self.anki_tag
    "aug"
  end

  def self.html_symbol
    "+"
  end
end
