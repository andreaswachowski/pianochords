# frozen_string_literal: true

require_relative 'note'
Dir[File.dirname(__FILE__) + '/chord/type/*.rb'].each { |file| require file.sub(/.rb\z/, '') }
require_relative 'chord/type.rb'

class Chord
  attr_reader :root, :inversion

  # cf. http://www.ctan.org/tex-archive/macros/latex/contrib/piano

  # TODO: Only chords with 4 notes are available at the moment.
  class << self; attr_reader :chord_types end
  # @chord_types = [:maj7, :seventh, :minor7, :halfdim, :dim7]
  @chord_types = Chord::Type.all.map { |c| c.downcase }

  class << self; attr_reader :inversions end
  @inversions = Chord::Type.all_inversions

  def initialize(root = Note.new(48), chord_type = :maj7, inversion = :root)
    raise ArgumentError.new("chord_type must be one of #{Chord.chord_types}") \
           unless Chord.chord_types.include?(chord_type)

    @chord_type = Chord::Type.create(chord_type)

    raise ArgumentError.new("inversion must be one of #{self.inversions}") \
           unless self.inversions.include?(inversion)

    @root = root.instance_of?(Note) ? root : Note.new(root)
    @inversion = inversion
  end

  # A triad has 3 inversions, seventh chords have 4
  # extend chords have 5 (or more)
  def inversions
    Chord.inversions[0..@chord_type.norm_interval_structure.size - 1]
  end

  def chord_type
    @chord_type.name.downcase.sub(/chord::type::/, '').to_sym
  end

  def akkordlage_in_chord_symbol
    conversion_hash =
      {
        terzlage: '(3)',
        quartlage: '(4)',
        quintlage: '(5)',
        sextlage: '(6)',
        septlage: '(7)',
        oktavlage: '(8)',
        nonlage: '(9)',
        thirteenlage: '(13)'
      }

    conversion_hash[akkordlage]
  end

  def to_symbol
    "#{@root.pitch_name}#{@chord_type.in_chord_symbol} #{akkordlage_in_chord_symbol}"
  end

  # Akkordlage = German, expresses the topmost interval within the chord.
  # Another way of designating the inversions
  def akkordlage
    conversion_hash =
      {
        '1' => :oktavlage,
        '2' => :nonlage,
        '3' => :terzlage,
        '4' => :quartlage,
        '5' => :quintlage,
        '6' => :sextlage,
        '7' => :septlage,
        '13' => :thirteenlage
      }

    conversion_hash[Chord.highest_interval_without_accidental(inverted_intervals)]
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
    # Tensions (9,11,13) are first converted to an octave lower,
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
    intervals = inverted_intervals.map do |i|
      # puts "Interval: #{i}, lower: #{Chord.tensions_one_octave_lower(i)}"
      Interval.new(Chord.tensions_one_octave_lower(i))
    end
    oktave = Interval.new('8')
    minimum = intervals.sort[0]
    minimum_interval_found = false
    intervals.map do |i|
      minimum_interval_found = minimum_interval_found || (i == minimum)
      minimum_interval_found ? @root + i : @root + i - oktave
    end
  end

  def self.tensions_one_octave_lower(tension)
    case tension
    when /^[b#]*9$/
      tension.gsub(/9/, '2')

    when /^[b#]*11$/
      tension.gsub(/11/, '4')

    when /^[b#]*13$/
      tension.gsub(/13/, '6')

    else
      tension
    end
  end

  def self.highest_interval_without_accidental(interval_array)
    # from an array of intervals, returns the last, removing
    # any accidental.

    interval_array[-1].slice(/[0-9]+/)
  end
end
