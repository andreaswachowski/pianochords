class Chord; end;
class Chord::Type; end;
class Chord::Type::MinNinth < Chord::Type
  def self.in_chord_symbol
    "-9"
  end

  def self.norm_interval_structure
    # We replace the root with the 9
    [ "2", "b3", "5", "b7" ]
  end

  def self.anki_filename
    "min9"
  end

  def self.anki_tag
    "minninth"
  end

  def self.html_symbol
    "-9"
  end
end
