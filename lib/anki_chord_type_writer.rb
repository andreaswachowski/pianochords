require_relative "chord"

class AnkiChordTypeWriter
  def initialize(chord_type)
    raise ArgumentError.new("Unknown chord type #{chord_type}, must be in #{Chord.chord_types.inspect}") unless Chord.chord_types.include?(chord_type)
    @chord_type = chord_type
  end

  def for_filename
    case @chord_type
    when :maj7
            "maj7"
    when :seventh
            "7"
    when :minor7
            "min7"
    when :halfdim
            "b7b5"
    when :dim7
            "dim7"
    end
  end

  def to_tag
    case @chord_type
    when :maj7
            "maj7"
    when :seventh
            "dominantsept"
    when :minor7
            "moll7"
    when :halfdim
            "halbvermindert"
    when :dim7
            "vermindert"
    end
  end

  def html_symbol
    ct = case @chord_type
    when :maj7
      "maj7"
    when :seventh
      "7"
    when :minor7
      "-7"
    when :halfdim
      "-7(&#9837;5)"
    when :dim7
      "o7"
    end

    "<sup>#{ct}</sup>"
  end
end
