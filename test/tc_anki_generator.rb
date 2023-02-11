# frozen_string_literal: true

require_relative '../lib/anki_generator'
require_relative 'test_helper'
require 'fileutils'

class TestAnkiGenerator < Test::Unit::TestCase
  def setup
    @loglevel = Logger::INFO
    @force = false
    @dirname = '/tmp/png'
    @ankifile = '/tmp/ankitestfile.txt'
  end

  def test_initialize
    raise ArgumentError.new("File #{@ankifile} exists, aborting test.") if File.exist?(@ankifile)

    AnkiGenerator.new(@dirname, @ankifile, @force, @loglevel)
    assert(Dir.exist?(@dirname))
    Dir.rmdir(@dirname)

    Dir.mkdir(@dirname)
    assert_nothing_raised(Exception) { AnkiGenerator.new(@dirname, @ankifile, @force, @loglevel) }
    assert(Dir.exist?(@dirname))
    Dir.rmdir(@dirname)

    File.open(@dirname, 'w') do
      assert_raises(ArgumentError) { AnkiGenerator.new(@dirname, @ankifile, @force, @loglevel) }
    end
    File.delete(@dirname)

    File.open(@ankifile, 'w') do
      assert_raises(ArgumentError) { AnkiGenerator.new(@dirname, @ankifile, @force, @loglevel) }
    end
    Dir.rmdir(@dirname)
    File.delete(@ankifile)
  end

  def test_generate
    # ---------------------------------------------------------------------
    # Ensure LaTeXPianoChordWriter is called with correct file name, and
    # Anki record is generated
    c = Chord.new('As', :maj7, :third)
    ankiGenerator = AnkiGenerator.new(@dirname, @ankifile, @force)

    LaTeXPianoChordWriter.any_instance.stubs(:generate_png).with(AnkiChordWriter.new(c).filename).returns(true)
    ankiGenerator.generate(['As'], [:maj7], [:third])
    LaTeXPianoChordWriter.any_instance.unstub(:generate_png)

    # Make sure one anki record is written to the file
    count = %x{wc -l #{@ankifile}}.split.first.to_i
    assert_equal(1, count)
    File.delete(@ankifile)

    # ---------------------------------------------------------------------
    # Generation of all inversions for a seventh/4-tone-chord
    Chord.new('As', :maj7, :third)

    ankiGenerator = AnkiGenerator.new(@dirname, @ankifile, @force)

    LaTeXPianoChordWriter.any_instance.stubs(:generate_png).returns(true)
    ankiGenerator.generate(['As'], [:maj7], Chord::Type.all_inversions)
    LaTeXPianoChordWriter.any_instance.unstub(:generate_png)

    count = %x{wc -l #{@ankifile}}.split.first.to_i
    assert_equal(4, count)
    File.delete(@ankifile)

    # ---------------------------------------------------------------------
    # Generation of all inversions for a triad/3-tone-chord in combination
    # with a seventh/4-tone-chord

    LaTeXPianoChordWriter.any_instance.stubs(:generate_png).returns(true)
    ankiGenerator.generate(['As'], [:aug, :maj7], Chord::Type.all_inversions)
    LaTeXPianoChordWriter.any_instance.unstub(:generate_png)

    count = %x{wc -l #{@ankifile}}.split.first.to_i
    assert_equal(7, count) # aug has 3 possible inversions, maj7 has 4
    File.delete(@ankifile)
  end

  def teardown
    FileUtils.rm_rf(@dirname) if Dir.exist?(@dirname)
    File.delete(@ankifile) if File.exist?(@ankifile)
  end
end
