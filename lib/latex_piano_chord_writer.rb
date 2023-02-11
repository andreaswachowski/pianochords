# frozen_string_literal: true

require_relative 'note'
require_relative 'chord'
require_relative 'anki_chord_writer'
require_relative 'logging'

class LaTeXPianoChordWriter
  include Logging

  # In particular, the keys go
  # Co, Cso, Do, Dso, Eo, Fo, Fso, Go, Gso, Ao, Aso, Bo,
  # Ct, Cst, Dt, Dst, Et, Ft, Fst, Gt, Gst, At, Ast, and Bt.

  attr_reader :chord

  def initialize(chord)
    @chord = chord
  end

  def generate_png(png_filename)
    # We assume we are in the correct directory
    file_prefix='anki_pianofile'
    texfile="#{file_prefix}.tex"

    File.open(texfile,'w') do |f|
      f << to_document(png_filename)
    end
    rc = system("latex -shell-escape #{texfile} >/dev/null 2>&1") || \
      logger.warn("LaTeX invocation failed with exit code, $? contains \"#{$?}\"")

    # remove all auxiliary files
    ['aux', 'dvi', 'log', 'ps'].each do |ext|
      name = "#{file_prefix}.#{ext}"
      File.delete(name) if File.exist?(name)
    end
    File.delete(texfile)
  end

  # Writes the chord as a sequence of notes suitable for the
  # \keyboard command of the piano.sty LaTeX package.
  def to_s
    # piano.sty provides two octaves of keys, the lower notes of which are
    # postfixed with "o", the higher with "t".
    # We assume that @chord.notes is returning the chords in the closest
    # possible position (within a given inversion).
    # We start writing the chord inside the first octave, and as soon as we
    # are crossing a C we continue in the next octave
    s = "\keyboard"
    octaves_offset = @chord.notes[0].val.div(12)
    @chord.notes.each { |n|
      postfix = n.val - octaves_offset*12 < 12 ? 'o' : 't'
      s+="[#{LaTeXPianoChordWriter::Note.new(n).to_s}#{postfix}]"
    }
    s
  end

  def to_document(outfile)
  <<CHORD
\\documentclass[preview,convert={density=150,outfile="#{outfile}"}]{standalone}
\\usepackage{piano}
\\usepackage{varwidth}

\\begin{document}
\\begin{varwidth}{\\linewidth}
\\begin{figure}[thpb]
\\#{to_s}
\\end{figure}
\\end{varwidth}
\\end{document}
CHORD
  end
end

class LaTeXPianoChordWriter::Note
  attr_reader :note

  def initialize(note)
    raise ArgumentError.new('note must be an instance of Note') \
      unless note.instance_of?(Note)
    @note = note
  end

  def to_s
    case @note.val.modulo(12)
    when 0
      'C'
    when 1
      'Cs'
    when 2
      'D'
    when 3
      'Ds'
    when 4
      'E'
    when 5
      'F'
    when 6
      'Fs'
    when 7
      'G'
    when 8
      'Gs'
    when 9
      'A'
    when 10
      'As'
    when 11
      'B'
    end
  end
end

