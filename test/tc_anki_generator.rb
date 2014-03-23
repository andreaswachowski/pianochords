require_relative "../lib/anki_generator"
require_relative "test_helper"
require 'fileutils'

class TestAnkiGenerator < Test::Unit::TestCase
  def setup
    @loglevel = Logger::INFO
    @force = false
    @dirname="/tmp/png"
    @ankifile = "/tmp/ankitestfile.txt"
  end

  def test_initialize
    raise ArgumentError.new("File #{@ankifile} exists, aborting test.") if File.exists?(@ankifile)

    AnkiGenerator.new(@dirname, @ankifile, @force, @loglevel)
    assert(Dir.exists?(@dirname))
    Dir.rmdir(@dirname)

    Dir.mkdir(@dirname)
    assert_nothing_raised(Exception) { AnkiGenerator.new(@dirname, @ankifile, @force, @loglevel) }
    assert(Dir.exists?(@dirname))
    Dir.rmdir(@dirname)

    File.open(@dirname, 'w') do |f|
      assert_raises(ArgumentError) { AnkiGenerator.new(@dirname, @ankifile, @force, @loglevel); }
    end
    File.delete(@dirname)

    File.open(@ankifile, 'w') do |f|
      assert_raises(ArgumentError) { AnkiGenerator.new(@dirname, @ankifile, @force, @loglevel); }
    end
    Dir.rmdir(@dirname)
    File.delete(@ankifile)
  end

  def test_generate
    c = Chord.new("As",:maj7,:third)
    l=LaTeXPianoChordWriter.new(c)
    l.expects(:generate_png).with(AnkiChordWriter.new(c).filename).returns(true)
    ankiGenerator = AnkiGenerator.new(@dirname,@ankifile,@force)
    ankiGenerator.generate([ "As" ], [ :maj7 ], [ :third ],l)
    File.delete(@ankifile)
  end

  #def test_generate_all
  #  ankifile = "ankichord_generatortest.tst"
  #  dirname = "/tmp/ankipng"
  #  ankiGenerator = AnkiGenerator.new(dirname,ankifile,Logger::INFO)
  #  ankiGenerator.generate(ankifile,Note.note_symbols,Chord.chord_types, [ :root ] )
  #end
  
  def teardown
    FileUtils.rm_rf(@dirname) if Dir.exists?(@dirname)
    File.delete(@ankifile) if File.exists?(@ankifile)
  end

end
