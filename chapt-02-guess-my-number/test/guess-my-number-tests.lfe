(defmodule guess-my-number-tests
  (export all)
  (import
    (from lfeunit-util
      (check-failed-assert 2)
      (check-wrong-assert-exception 2))
    (from guess-my-number
      (ash 2)
      (bigger 1)
      (guess 1)
      (guess-my-number 0)
      (smaller 1)
      (start-over 0))))

(include-lib "deps/lfeunit/include/lfeunit-macros.lfe")
(include-lib "include/guess-my-number-records.lfe")

(deftest ash
  (is-equal 50 (ash 101 -1)))

(deftest bigger
  (let ((game (guess-my-number)))
    (let ((updated-game (bigger game)))
      (is (is-game updated-game))
      (is-equal 51 (game-small updated-game)))))

(deftest guess
  (let ((game (guess-my-number)))
    (is-equal 50 (guess game))))

(deftest guess-my-number
  (is (is-game (guess-my-number))))

(deftest smaller
  (let ((game (guess-my-number)))
    (let ((updated-game (smaller game)))
      (is (is-game updated-game))
      (is-equal 49 (game-big updated-game)))))

(deftest start-over
  (is (is-game (start-over))))
