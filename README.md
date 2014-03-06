land-of-lfe
===========

Land of Lisp examples using Lisp-flavoured Erlang

## Dependencies

This project assumes that you have `rebar` installed somewhere in your `$PATH`.

This project depends upon the following, which are installed to the `deps`
directory of this project when you run `make deps`:

* `LFE` (Lisp Flavoured Erlang; needed only to compile)
* `lfeunit` (needed only to run the unit tests)

## Installation

Just add it to your `rebar.config` deps:

```erlang
{deps, [
  {land-of-lfe, ".*", {git, "git@github.com:jschairb/land-of-lfe.git", "master"}}
]}.
```

And then do the usual:

```bash

$ rebar get-deps
$ rebar compile
```

## Usage

Nothing to see here.

## Links

* [`rebar'](https://github.com/rebar/rebar)
* [`LFE`](https://github.com/rvirding/lfe)
* [`lfeunit`](https://github.com/lfe/lfeunit)
