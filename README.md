Glee is a toy language inspired by [Joy](http://en.wikipedia.org/wiki/Joy_%28programming_language%29). Unlike Joy, Glee has integers and booleans. See `example.glee` for an example of Glee code. It's primitive combinators are:

* `k`, where `[B] [A] k == A`
* `cake`, where `[B] [A] cake == [[B] A] [A [B]]`
* `choose`, where `true [B] [A] choose == [B]` and `false [B] [A] choose == [A]`
* `uncons`, where `[A B] uncons == [A] [B]`
* Arithmetic operators: `+`, `-`, `*`, `/`
* Boolean operators: `&&`, `not`

All other words are derived from these. The base is inspired by an article [The Theory of Concatenative Combinators](http://tunes.org/~iepos/joy.html) by Brent Kerby.

## Running

Running Glee requires OCaml and [Menhir](http://gallium.inria.fr/~fpottier/menhir/).

Clone the repository:

    git clone https://github.com/andreas/glee

Compile the sources:

    cd glee
    make

This produces an executable `glee`. To run Glee:

    ./glee

This will put you in an interactive console. You can optionally specify an input file to run before going into interactive mode:

    ./glee example.glee

## Copyright

Copyright (c) 2012 Andreas Garnæs. See [LICENSE](LICENSE) for details.

MENTION BOT TEST
