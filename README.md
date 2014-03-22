pianochords
===========

Generator for an Anki deck to learn Jazz piano chord layouts

## Overview

This might be handy if you learn Jazz piano and want to memorize
chords in order to be able to read lead sheets.

You can use this program to generate an [Anki deck](http://ankisrs.net/)
containing basic question/answer pairs as follows:

[![sample question answer pair](/example.png "A sample question/answer pair")

Various chord types are supported (e.g. maj7, dominant 7th, minor 7th, halfdiminished,
diminished) as are different inversions (to the right of the chord symbol
is a circled number, representing the topmost chord interval).

## Usage
TBD

## Prerequisites
You need LaTeX with the [piano.sty](http://www.ctan.org/tex-archive/macros/latex/contrib/piano).
And Ruby, of course. I used Ruby 1.9.3 and Ruby 2.0 during development.

## Development
Start reading `tc_anki_generator.rb` and descend from there.

Run the tests with `ruby ts_all.rb`

## Remarks
I patched `piano.sty` and modified the picture dimensions to
from `\begin{picture}(14,4.5)` to `\begin{picture}(13.9,4.05)` in order to
get rid of unwanted borders (and therefore incorrect centering).


