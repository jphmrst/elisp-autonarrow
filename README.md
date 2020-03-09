# elisp-autonarrow

Simple elisp function which applies buffer narrowing based on string
patterns in a file.

The idea is to either use this function as a mode-hook, or call it
from a mode-hook --- then the area you denoted will be immediately
visible upon starting emacs, with all of the surrounding cruft hidden.

As usual for narrowing, use

  C-x n w

to make the whole thing visible again.


