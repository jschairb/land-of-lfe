# Chapter 2 - Guess My Number

Pick a number between 1 and 100, have LFE guess it through the REPL.

## Usage

From the directory:

```bash
    $ rebar get-deps
    $ rebar compile
    $ make shell-no-deps
```

Then:

```lisp
(slurp '"./src/guess-my-number.lfe")
;; #(ok guess-my-number)
(set game (guess-my-number))
;; #(game 100 1)
(guess game)
;; 50
(set game (smaller game))
;; #(game 49 1)
(guess game)
;; 25
(set game (bigger game))
;; #(game 49 26)
(guess game)
;; 37
(set game (bigger game))
;; #(game 49 38)
(guess game)
;; 43
(set game (smaller game))
;; #(game 42 38)
(guess game)
;; 40
(set game (bigger game))
;; #(game 42 41)
(guess game)
;; 41
(set game (bigger game))
;; #(game 42 42)
(guess game)
;; 42
```

To run the unit tests:

```bash
    $ make check-no-deps
```

## Differences From The Book

* Lack of global variables: LFE does not have the concept of global variables or really even the idea of mutability, so establishing a global variable is out of the question. The [normal method for tracking state](https://github.com/rvirding/lfe/blob/master/examples/internal-state.lfe) is to pass a record or function around. I implemented this by creating a record of the bigger and smaller values and updating the fields before querying it for the guess. This is different than sending `bigger` or `smaller` and having the side-effect of updating state and returning the guess. You can read more about [LFE Records](http://lfe.github.io/user-guide/data/4.html).

* `ash` implementation: While this is a standard function in many lisps, it is not included in LFE. I suspect that's because of how trivial it is to implement because there is an existing operator in Erlang, [`bsl`](http://erlang.org/doc/reference_manual/expressions.html#id77743).

## Dependencies

This project assumes that you have `rebar` installed somwhere in your `$PATH`.

This project depends upon the following, which installed to the `deps`
directory of this project when you run `make deps`:

* `LFE` (Lisp Flavored Erlang; needed only to compile)
* `lfeunit` (needed only to run the unit tests)

## Links

* [rebar](https://github.com/rebar/rebar)
* [LFE](https://github.com/rvirding/lfe)
* [lfeunit](https://github.com/lfe/lfeunit)
