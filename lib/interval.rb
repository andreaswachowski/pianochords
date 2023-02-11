# frozen_string_literal: true

class Interval
  class << self; attr_reader :intervals end
  @intervals = ['b1', '1', '#1', \
                'b2', '2', '#2', \
                'b3', '3', '#3', \
                'b4', '4', '#4', \
                'b5', '5', '#5', \
                'b6', '6', '#6', \
                'b7', '7', '#7', \
                '8']

  class << self; attr_reader :intervals_to_halfsteps end
  # rubocop:disable Layout/HashAlignment
  @intervals_to_halfsteps =
    { 'b1' => -1, '1' => 0, '#1' => 1,
      'b2' => 1, '2' => 2, '#2' => 3,
      'b3' => 3, '3' => 4, '#3' => 5,
      'b4' => 4, '4' => 5, '#4' => 6,
      'b5' => 6, '5' => 7, '#5' => 8,
      'b6' => 8, '6' => 9, '#6' => 10,
      'b7' => 10, '7' => 11, '#7' => 12,
                  '8' => 12,
      'b9' => 13, '9' => 14, '#9' => 15,
      'b11' => 16, '11' => 17, '#11' => 18,
      'b13' => 20, '13' => 21, '#13' => 22 }
  # rubocop:enable Layout/HashAlignment

  attr_reader :interval, :direction

  def initialize(interval, direction = :up)
    raise ArgumentError.new('Interval must be between 1 and 7, and optionally raised with # or lowered with b') unless Interval.intervals.include?(interval)
    raise ArgumentError.new('direction must be :up or :down') unless [:up, :down].include?(direction)

    @interval = interval
    @direction = direction
  end

  def to_s
    "#{@interval} #{@direction}"
  end

  # Not sure how to properly define ==. Currently, I only care for the
  # length, thus ignoring the direction.
  def ==(other)
    Interval.intervals_to_halfsteps[@interval] == Interval.intervals_to_halfsteps[other.interval]
  end

  def <(other)
    Interval.intervals_to_halfsteps[@interval] < Interval.intervals_to_halfsteps[other.interval]
  end

  def <=(other)
    (self < other) || (self == other)
  end

  def >(other)
    other < self
  end

  def <=>(other)
    return 0 if self == other
    return -1 if self < other

    return 1
  end

  def -@
    Interval.new(self.interval, self.direction == :up ? :down : :up)
  end

  def half_steps
    @direction == :up ? Interval.intervals_to_halfsteps[@interval] : -Interval.intervals_to_halfsteps[@interval]
  end
end
