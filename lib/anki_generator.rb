# frozen_string_literal: true

require_relative 'latex_piano_chord_writer'
require_relative 'anki_chord_writer'
require_relative 'chord'
require_relative 'logging'

# TODO: (See below)
# - Write pianochord_generator to be used from the command line
#   cf. http://rubylearning.com/blog/2011/01/03/how-do-i-make-a-command-line-tool-in-ruby/
#
# Improve test coverage:
# - test variants of generate invocations, with or without default
#   arguments (mock out the latex generation to save time during execution)
# - check the output of the anki_import_file (newlines correct?)

class AnkiGenerator
  include Logging

  def initialize(pngdirectory = 'png', ankifile = 'ankichords.txt', force = false, loglevel = Logger::WARN, logtarget = $stderr)
    Logging.configure_logger(logtarget)
    logger.level = loglevel

    if !File.exist?(pngdirectory)
      logger.debug "Creating directory #{pngdirectory} to hold PNG files ..."
      Dir.mkdir(pngdirectory)
    elsif File.exist?(pngdirectory) && !File.directory?(pngdirectory)
      raise ArgumentError.new("Directory #{pngdirectory} cannot be created, a file exists instead in its place.")
    else
      logger.debug "Using existing directory #{pngdirectory} to hold PNG files ..."
    end

    raise ArgumentError.new("File #{ankifile} exists already, aborting.") if File.exist?(ankifile) && !force

    @ankifile = ankifile
    @pngdirectory = pngdirectory
  end

  # Expects a filename in which to store the anki deck information.
  def generate(root_notes = Note.note_symbols,
               chordtypes = Chord.chord_types,
               inversions = Chord.inversions)

    File.open(@ankifile, 'w') do |f|
      originaldir = Dir.pwd
      Dir.chdir(@pngdirectory)
      root_notes.each do |root|
        chordtypes.each do |chordtype|
          valid_inversions = inversions & Chord::Type.create(chordtype).inversions
          valid_inversions.each do |inversion|
            c = Chord.new(root, chordtype, inversion)
            a = AnkiChordWriter.new(c)
            logger.info "Generating Anki question for #{c.to_symbol}"
            LaTeXPianoChordWriter.new(c).generate_png(a.filename)
            f.puts a.importfile_line
          end
        end
      end
      Dir.chdir(originaldir)
    end
  end
end
