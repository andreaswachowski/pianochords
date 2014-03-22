require_relative "anki_generator"
require "logger"
require "test/unit"
require 'fileutils'

class TestAnkiGenerator < Test::Unit::TestCase
  def setup
    @loglevel = Logger::INFO
    @dirname="/tmp/png"
    @ankifile = "/tmp/ankitestfile.txt"
  end

  def test_initialize
    raise ArgumentError.new("File #{@ankifile} exists, aborting test.") if File.exists?(@ankifile)

    AnkiGenerator.new(@dirname, @ankifile, @loglevel)
    assert(Dir.exists?(@dirname))
    Dir.rmdir(@dirname)

    Dir.mkdir(@dirname)
    assert_nothing_raised(Exception) { AnkiGenerator.new(@dirname, @ankifile, @loglevel) }
    assert(Dir.exists?(@dirname))
    Dir.rmdir(@dirname)

    File.open(@dirname, 'w') do |f|
      assert_raises(ArgumentError) { AnkiGenerator.new(@dirname, @ankifile, @loglevel); }
    end
    File.delete(@dirname)

    File.open(@ankifile, 'w') do |f|
      assert_raises(ArgumentError) { AnkiGenerator.new(@dirname, @ankifile, @loglevel); }
    end
    Dir.rmdir(@dirname)
    File.delete(@ankifile)
  end

  def test_generate
    ankiGenerator = AnkiGenerator.new(@dirname,@ankifile)
    ankiGenerator.generate(@ankifile, [ "As" ], [ :maj7 ], [ :third ])
    File.delete(@ankifile)
  end

  def test_generate_all
    ankifile = "ankichord_generatortest.tst"
    dirname = "/tmp/ankipng"
    ankiGenerator = AnkiGenerator.new(dirname,ankifile,Logger::INFO)
    ankiGenerator.generate(ankifile)
  end
  
  def teardown
    FileUtils.rm_rf(@dirname) if Dir.exists?(@dirname)
    File.delete(@ankifile) if File.exists?(@ankifile)
  end

end
