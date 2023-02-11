# frozen_string_literal: true

require_relative '../lib/latex_piano_chord_writer'
require_relative 'test_helper'
require_relative 'note_test_helper'

class TestLaTeXPianoChordWriter < Test::Unit::TestCase
  def test_to_s
    assert_equal("\keyboard[Co][Eo][Go][Bo]",LaTeXPianoChordWriter.new(Chord.new('C')).to_s)
    assert_equal("\keyboard[Eo][Go][Bo][Ct]",LaTeXPianoChordWriter.new(Chord.new('C',:maj7,:first)).to_s)
    assert_equal("\keyboard[Go][Bo][Ct][Et]",LaTeXPianoChordWriter.new(Chord.new('C',:maj7,:second)).to_s)
    assert_equal("\keyboard[Bo][Ct][Et][Gt]",LaTeXPianoChordWriter.new(Chord.new('C',:maj7,:third)).to_s)
  end

  def test_generate_png
    pngfilename = 'chord.png'
    l = LaTeXPianoChordWriter.new(Chord.new('C'))
    File.expects(:open).with('anki_pianofile.tex','w')
    File.expects(:to_document).with(pngfilename)
    l.expects(:system).with('latex -shell-escape anki_pianofile.tex >/dev/null 2>&1').once.returns(true)
    [ 'aux', 'dvi', 'log', 'ps', 'tex'].each { |ext| File.expects(:delete).with("anki_pianofile.#{ext}").once }
    l.generate_png(pngfilename)
  end

  def test_to_document
  s = <<CHORD
\\documentclass[preview,convert={density=150,outfile="abcdefile"}]{standalone}
\\usepackage{piano}
\\usepackage{varwidth}

\\begin{document}
\\begin{varwidth}{\\linewidth}
\\begin{figure}[thpb]
\\keyboard[Co][Eo][Go][Bo]
\\end{figure}
\\end{varwidth}
\\end{document}
CHORD
    assert_equal(s,LaTeXPianoChordWriter.new(Chord.new).to_document('abcdefile'))
  end
end

class TestLaTeXPianoChordWriter::Note < Test::Unit::TestCase
  def test_to_s
    assert_equal('B', LaTeXPianoChordWriter::Note.new(NoteTestHelper.new_note(47)).to_s)
    assert_equal('C', LaTeXPianoChordWriter::Note.new(NoteTestHelper.new_note(48)).to_s)
    assert_equal('Cs',LaTeXPianoChordWriter::Note.new(NoteTestHelper.new_note(49)).to_s)
    assert_equal('D', LaTeXPianoChordWriter::Note.new(NoteTestHelper.new_note(50)).to_s)
    assert_equal('Ds',LaTeXPianoChordWriter::Note.new(NoteTestHelper.new_note(51)).to_s)
    assert_equal('E', LaTeXPianoChordWriter::Note.new(NoteTestHelper.new_note(52)).to_s)
    assert_equal('F', LaTeXPianoChordWriter::Note.new(NoteTestHelper.new_note(53)).to_s)
    assert_equal('Fs',LaTeXPianoChordWriter::Note.new(NoteTestHelper.new_note(54)).to_s)
    assert_equal('G', LaTeXPianoChordWriter::Note.new(NoteTestHelper.new_note(55)).to_s)
    assert_equal('Gs',LaTeXPianoChordWriter::Note.new(NoteTestHelper.new_note(56)).to_s)
    assert_equal('A', LaTeXPianoChordWriter::Note.new(NoteTestHelper.new_note(57)).to_s)
    assert_equal('As',LaTeXPianoChordWriter::Note.new(NoteTestHelper.new_note(58)).to_s)
    assert_equal('B', LaTeXPianoChordWriter::Note.new(NoteTestHelper.new_note(59)).to_s)
    assert_equal('C', LaTeXPianoChordWriter::Note.new(NoteTestHelper.new_note(60)).to_s)
  end

end
