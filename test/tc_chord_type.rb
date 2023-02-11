# frozen_string_literal: true

require_relative '../lib/chord/type'
require_relative 'note_test_helper'
require_relative 'test_helper'

class TestChordType < Test::Unit::TestCase
  def test_inversions
    assert_equal(%i[root first second third], Chord::Type::Maj7.inversions)
  end
end
