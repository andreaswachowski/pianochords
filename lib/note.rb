# frozen_string_literal: true

require_relative 'interval'

#  TODO: Introduce key so that individual notes are named according to key
#  TODO: Allow "#" and "b" as accidentals in the note_symbols (or at least in the constructors for the notes, as strings
class Note
  class << self; attr_reader :note_symbols end

  @note_symbols = %w[c cis des
                     d dis es
                     e eis fes
                     f fis ges
                     g gis as
                     a ais bes
                     b bis ces]

  class << self; attr_reader :note_symbols_to_accidentals end
  @note_symbols_to_accidentals =
    {
      'c' => nil, 'cis' => :sharp, 'des' => :flat,
      'd' => nil, 'dis' => :sharp, 'es' => :flat,
      'e' => nil, 'eis' => :sharp, 'fes' => :flat,
      'f' => nil, 'fis' => :sharp, 'ges' => :flat,
      'g' => nil, 'gis' => :sharp, 'as' => :flat,
      'a' => nil, 'ais' => :sharp, 'bes' => :flat,
      'b' => nil, 'bis' => :sharp, 'ces' => :flat
    }

  @@offsets_with_accidentals = [1, 3, 6, 8, 10]

  # Notes are internally just unsigned integer values, 12 values per octave
  # Middle C is C4 (48), A4 is 440 Hz
  # C0:   0 -  11
  # C1:  12 -  23
  # C2:  24 -  35
  # C3:  36 -  47
  # C4:  48 -  59
  # C5:  60 -  71
  # C6:  72 -  83
  # C7:  84 -  95
  # C8:  96 - 107
  # C9: 108 - 119
  # see also http://en.wikipedia.org/wiki/Scientific_pitch_notation
  #
  # From this number one can infer a pitch as well as a musical notation sign (together with an accidental)
  attr_reader :val
  attr_reader :accidental

  def initialize(value = 48, accidental = nil)
    if ((0..119).include?(value))
      @val = value
      if (Note.accidental_required?(value) && accidental.nil?)
        raise ArgumentError.new("Must provide accidental for #{value} which could be either #{Note.new(value, :flat).pitch_name} or #{Note.new(value, :sharp).pitch_name}")
      else
        @accidental = accidental
      end
    elsif value.instance_of?(String) && Note.note_symbols.include?(value.downcase)
      value = value.downcase
      @val = 48 + Note.offset(value)
      @accidental = Note.note_symbols_to_accidentals[value]
    else
      raise ArgumentError.new("Note value is #{value.inspect}, but must be between 0 and 119, or one of #{Note.note_symbols}")
    end
  end

  def ==(other)
    @val == other.val && @accidental == other.accidental
  end

  def scientific_notation
    "#{pitch_name}#{octave_number}"
  end

  def +(other)
    newval = @val + other.half_steps
    # TODO: The accidental in fact depends on the key, instead we arbitrarily
    # default to sharp
    accidental = Note.accidental_required?(newval) ? :sharp : nil
    Note.new(newval, accidental)
  end

  def -(other)
    self + (-other)
  end

  def pitch_name
    name = case @val.modulo(12)
           when 0
             @accidental == :sharp ? 'Bis' : 'C'
           when 1
             @accidental == :sharp ? 'Cis' : 'Des'
           when 2
             'D'
           when 3
             @accidental == :sharp ? 'Dis' : 'Es'
           when 4
             @accidental == :flat ? 'Fes' : 'E'
           when 5
             @accidental == :sharp ? 'Eis' : 'F'
           when 6
             @accidental == :sharp ? 'Fis' : 'Ges'
           when 7
             'G'
           when 8
             @accidental == :sharp ? 'Gis' : 'As'
           when 9
             'A'
           when 10
             @accidental == :sharp ? 'Ais' : 'Bes'
           when 11
             @accidental == :flat ? 'Ces' : 'B'
           end
    name
  end

  # Gives the offset from a C to a given note symbol in halftones
  def self.offset(note_symbol)
    # TODO: how to handle english names?
    case note_symbol.downcase
    when 'bis', 'c'
      0
    when 'cis', 'des'
      1
    when 'd'
      2
    when 'dis', 'es'
      3
    when 'e', 'fes'
      4
    when 'eis', 'f'
      5
    when 'fis', 'ges'
      6
    when 'g'
      7
    when 'gis', 'as'
      8
    when 'a'
      9
    when 'ais', 'bes', 'bflat'
      10
    when 'b', 'ces'
      11
    else
      raise ArgumentError.new("unknown note symbol #{note_symbol}")
    end
  end

  def self.accidental_required?(value)
    @@offsets_with_accidentals.include?(value.modulo(12))
  end

  def octave_number
    @val / 12
  end
end
