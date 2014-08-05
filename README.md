pianochords
===========

Generator for an Anki deck to learn Jazz piano chord layouts

## Overview

This might be handy if you learn Jazz piano and want to memorize
chords in order to be able to read lead sheets.

You can use this program to generate an [Anki deck](http://ankisrs.net/)
containing basic question/answer pairs as follows:

![sample question answer pair](/example.png "A sample question/answer pair")

The question is the chord symbol, the answer is the layout of the chord on
the piano keyboard.

Imagine sitting at the piano with the mobile version of Anki on an iPad or similar,
practicing chords, or practicing mentally while on the road.

Various chord types (e.g. maj7, dominant, half-diminished, etc.) are supported 
as are different inversions (first, second, ...). In the example above, the
circled number represents the chord interval that appears highest in
the chord.

## Usage
### For the impatient
There's a pre-generated deck available. Just download
`pianochords_ankideck.tgz` and [import it in Anki](http://ankisrs.net/docs/manual.html#importing).
Make sure you follow the advise in [Anki's section on Importing
Media](http://ankisrs.net/docs/manual.html#importing-media). Alternatively, use the [shared deck provided at Ankiweb](https://ankiweb.net/shared/info/946752090).

If you want to learn just certain chords, for example while practicing a particular piece, analyse the 
lead sheet at the piano and find the chord inversions you are going to use. Then tag the corresponding chords in
the deck, e.g. with `song:all_the_things_you_are`. Now use the tag to create a filtered deck, and practice exactly the chords you need.

### Using the generator
For a start, try

    bin/pianochords generate -r c

This creates a file `ankichords.txt` containing question/answer pairs for the four
inversions of Cmaj7, and a directory `png` containing the four corresponding PNG files.

Run

    bin/pianochords

or better

    bin/pianochords help generate

for an overview of options.

## Prerequisites
You need LaTeX with [piano.sty](http://www.ctan.org/tex-archive/macros/latex/contrib/piano) and [standalone.cls](http://www.ctan.org/tex-archive/macros/latex/contrib/standalone). And Ruby, of course. I used Ruby 1.9.3 and Ruby 2.0 during development.

## Development
Start reading `bin/pianochords`, or skip directly to `lib/anki_generator.rb` and descend from there.

Run the tests with `rake test`

## Remarks and open issues
* The code internally uses a mixture of English and German musical
  terminology, and the file names of the generated PNGs reflect that, too.
* I recommend to patch `piano.sty` and modify the picture dimensions
  from `\begin{picture}(14,4.5)` to `\begin{picture}(13.9,4.05)` in order to
  get rid of unwanted borders (and therefore incorrect centering).
