require_relative 'note'
Dir[File.dirname(__FILE__) + "/chord/type/*.rb"].each { |file| require file.sub(/.rb\z/,'') }
require_relative 'chord/type.rb'

class Chord
  attr_reader :root
  attr_reader :inversion

  # cf. http://www.ctan.org/tex-archive/macros/latex/contrib/piano

  # TODO: Only chords with 4 notes are available at the moment.
  class << self; attr_reader :chord_types end
  #@chord_types = [:maj7, :seventh, :minor7, :halfdim, :dim7]
  @chord_types = Chord::Type.all.map { |c| c.downcase }

  class << self; attr_reader :inversions end
  @inversions = Chord::Type.all_inversions

  def initialize(root=Note.new(48),chord_type=:maj7,inversion=:root)
    raise ArgumentError.new("chord_type must be one of #{Chord.chord_types.to_s}") \
           unless Chord.chord_types.include?(chord_type)
    @chord_type = Chord::Type.create(chord_type)

    raise ArgumentError.new("inversion must be one of #{self.inversions.to_s}") \
           unless self.inversions.include?(inversion)
    @root = root.instance_of?(Note) ? root : Note.new(root)
    @inversion = inversion
  end

  # A triad has 3 inversions, seventh chords have 4
  # extend chords have 5 (or more)
  def inversions
    Chord.inversions[0..@chord_type.norm_interval_structure.size-1]
  end

  def chord_type
    @chord_type.name.downcase.sub(/chord::type::/,'').to_sym
  end

  def akkordlage_in_chord_symbol
    case akkordlage
    when :terzlage
      "(3)"
    when :quartlage
      "(4)"
    when :quintlage
      "(5)"
    when :sextlage
      "(6)"
    when :septlage
      "(7)"
    when :oktavlage
      "(8)"
    when :nonlage
      "(9)"
    end
  end

  def to_symbol
    "#{@root.pitch_name}#{@chord_type.in_chord_symbol} #{akkordlage_in_chord_symbol}"
  end

  # Akkordlage = German, expresses the topmost interval within the chord.
  # Another way of designating the inversions
  def akkordlage
    # first -1 to get the highest interval
    # second -1 to get rid of potential accidental
    case inverted_intervals[-1][-1]
    when "1"
      :oktavlage
    when "2"
      :nonlage
    when "3"
      :terzlage
    when "4"
      :quartlage
    when "5"
      :quintlage
    when "6"
      :sextlage
    when "7"
      :septlage
    end
  end

  def inverted_intervals
    case @inversion
    when :root
      @chord_type.norm_interval_structure
    when :first
      @chord_type.norm_interval_structure.rotate
    when :second
      @chord_type.norm_interval_structure.rotate(2)
    when :third
      @chord_type.norm_interval_structure.rotate(3)
    end
  end

  def notes
    # I assume that the tensions are written an octave lower,
    # that is, a 9 is a 2, a 13 is a 6, etc.
    # Thus, the root inversion is an ascending sequence,
    # and any other inversion are two ascending sequences, the second one
    # usually starting with a root, or, in a rootless ninth, with the 9/2,
    # except an octave higher.
    # Hence we have to look for the smallest interval (and not just the
    # root) to determine when to add an octave.
    #
    # Finding the minimum in the given inverted_intervals is not a numeric
    # comparison because there are strings like "b2" or "#2".
    intervals = inverted_intervals.map { |i| Interval.new(i) }
    oktave = Interval.new("8")
    minimum = intervals.sort[0]
    minimum_interval_found = false
    intervals.map { |i|
      minimum_interval_found = minimum_interval_found || (i == minimum)
      minimum_interval_found ? @root+i : @root+i-oktave
    }
  end
end
