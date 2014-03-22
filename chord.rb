require_relative 'note'

class Chord
  attr_reader :root
  attr_reader :chord_type
  attr_reader :inversion

  # cf. http://www.ctan.org/tex-archive/macros/latex/contrib/piano

  # TODO: Only chords with 4 notes are available at the moment.
  class << self; attr_reader :chord_types end
  @chord_types = [:maj7, :seventh, :minor7, :halfdim, :dim7]
  class << self; attr_reader :inversions end
  @inversions = [:root, :first, :second, :third]

  def initialize(root=Note.new(48),chord_type=:maj7,inversion=:root)
    raise ArgumentError.new("chord_type must be one of #{Chord.chord_types.to_s}") \
           unless Chord.chord_types.include?(chord_type)
    raise ArgumentError.new("inversion must be one of #{Chord.inversions.to_s}") \
           unless Chord.inversions.include?(inversion)
    @root = root.instance_of?(Note) ? root : Note.new(root)
    @chord_type = chord_type
    @inversion = inversion
  end

  # Text form of accord symbol
  #
  def chord_type_symbol
    case @chord_type
    when :maj7
      "maj7"
    when :seventh
      "7"
    when :minor7
      "-7"
    when :halfdim
      "-7(b5)"
    when :dim7
      "o7"
    end
  end

  def akkordlage_in_chord_symbol
    case akkordlage
    when :septlage
      "(1)"
    when :oktavlage
      "(8)"
    when :terzlage
      "(3)"
    when :quintlage
      "(5)"
    end
  end

  def to_symbol
    "#{@root.pitch_name}#{chord_type_symbol} #{akkordlage_in_chord_symbol}"
  end

  # Akkordlage = German, expresses the topmost interval within the chord.
  # Another way of designating the inversions
  def akkordlage
    case @inversion
    when :root
      :septlage
    when :first
      :oktavlage
    when :second
      :terzlage
    when :third
      :quintlage
    end
  end

  def interval_structure
    case @inversion
    when :root
      norm_interval_structure
    when :first
      norm_interval_structure.rotate
    when :second
      norm_interval_structure.rotate(2)
    when :third
      norm_interval_structure.rotate(3)
    end
  end

  def notes
    intervals = interval_structure.map { |i| Interval.new(i) }
    oktave = Interval.new("8")
    root_found = false
    intervals.map { |i|
      root_found = root_found || (i.interval == "1")
      root_found ? @root+i : @root+i-oktave
    }
  end

  protected

  def norm_interval_structure
    case @chord_type
    when :maj7
      [ "1", "3", "5", "7" ]
    when :seventh
      [ "1", "3", "5", "b7" ]
    when :minor7
      [ "1", "b3", "5", "b7" ]
    when :halfdim
      [ "1", "b3", "b5", "b7" ]
    when :dim7
      [ "1", "b3", "b5", "6" ]
    else
      [ "unknown chord type" ]
    end
  end

end
