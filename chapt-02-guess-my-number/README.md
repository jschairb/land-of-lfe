# Chapter 2 - Guess My Number

Think of a number and have LFE guess it through the REPL.

```lisp
(slurp '"/.src/guess-my-number.lfe")
;; > #(ok guess-my-number)
(set game (new-game))
;; #(game 100 1)
(guess-my-number game)
;; 50
(bigger game)
;; 75
```

## Usage

From the directory

```bash
    $ rebar get-deps
    $ rebar compile
    $ make shell-no-deps
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
