(defmodule guess-my-number-tests
  (export all)
  (import
    (from lfeunit-util
      (check-failed-assert 2)
      (check-wrong-assert-exception 2))
    (from guess-my-number
      (ash 2)
      (bigger 1)
      (guess-my-number 1)
      (new-game 0)
      (smaller 1)
      (start-over 0))))

(include-lib "deps/lfeunit/include/lfeunit-macros.lfe")
(include-lib "include/guess-my-number-records.lfe")

(deftest ash
  (is-equal 50 (ash 101 -1)))

(deftest bigger
  (let ((game (make-game big 100 small 50)))
    (is-equal 75 (bigger game))))

(deftest new-game
  (is (is-game (new-game))))

(deftest guess-my-number
  (let ((game (new-game)))
    (is-equal 50 (guess-my-number game))))

(deftest smaller
  (let ((game (make-game big 50 small 1)))
    (is-equal 25 (smaller game))))

(deftest start-over
  (is (is-game (start-over))))
