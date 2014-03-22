class Chord; end;
class Chord::Type; end;
class Chord::Type::Min7
  def self.in_chord_symbol
    "-7"
  end

  def self.norm_interval_structure
    [ "1", "b3", "5", "b7" ]
  end

  def self.anki_filename
    "min7"
  end

  def self.anki_tag
    "moll7"
  end

  def self.html_symbol
    "-7"
  end
end
