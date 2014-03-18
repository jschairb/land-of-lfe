(defmodule guess-my-number
  (export all))

(include-lib "include/guess-my-number-records.lfe")

;; (slurp '"./src/guess-my-number.lfe")
;; (set game (new-game))
;; (guess-my-number game)
;; > 50
;; (bigger game)
;; > 75
;; ... more until correct guesses
;; (set game (start-over))

(defun ash (integer count)
  (bsl integer count))

(defun bigger (game)
  (set-game-small game (+ 1 (guess-my-number game)))
  (guess-my-number game))

(defun guess-my-number (game)
  (ash (+ (game-big game) (game-small game)) -1))

(defun new-game ()
  (make-game))

(defun smaller (game)
  (set-game-big game (- 1 (guess-my-number game)))
  (guess-my-number game))

(defun start-over ()
  (new-game))