# Chapter 2 - Guess My Number

Think of a number and have LFE guess it through the REPL.

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
