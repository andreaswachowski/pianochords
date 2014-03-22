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

Imagine sitting at the piano with the mobile version of Anki on a table,
practicing chords. Having said that, you could just as well practice purely
mentally while on the road.

Various chord types (e.g. maj7, dominant, half-diminished, etc.) are supported 
as are different inversions (first, second, ...). In the example above, the
circled number represents the chord interval that appears highest in
the chord.

## Usage
### For the impatient
There's a pre-generated deck available. Just download
`pianochords_ankideck.tgz` and [import it in Anki](http://ankisrs.net/docs/manual.html#importing).
Make sure you follow the advise in [Anki's section on Importing
Media](http://ankisrs.net/docs/manual.html#importing-media).

To practice for a song, analyse the lead sheet at the piano and find the
chord inversions you are going to use. Then tag the corresponding chords in
the deck, e.g. with `song:all_the_things_you_are`. Create a filtered deck
using that tag, and practice exactly the chords you need.

### Using the generator
For a start, try

    bin/pianochords generate -r c

Run

    bin/pianochords

or better

    bin/pianochords help generate

for an overview of options.

## Prerequisites
You need LaTeX with the [piano.sty](http://www.ctan.org/tex-archive/macros/latex/contrib/piano).
And Ruby, of course. I used Ruby 1.9.3 and Ruby 2.0 during development.

## Development
Start reading `bin/pianochords`, or skip directly to `lib/anki_chord_generator.rb` and descend from there.

Run the tests with `rake test`

## Remarks and open issues
* The code internally uses a mixture of English and German musical
  terminology, and the file names of the generated PNGs reflect that, too.
* I recommend to patch `piano.sty` and modify the picture dimensions
  from `\begin{picture}(14,4.5)` to `\begin{picture}(13.9,4.05)` in order to
  get rid of unwanted borders (and therefore incorrect centering).
