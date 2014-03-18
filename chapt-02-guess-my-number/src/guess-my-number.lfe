(defmodule guess-my-number
  (export all))

(include-lib "include/guess-my-number-records.lfe")

(defun ash (integer count)
  "For more info: http://clhs.lisp.se/Body/f_ash.htm"
  (bsl integer count))

(defun bigger (game)
  (set-game-small game (+ 1 (guess game))))

(defun guess (game)
  (ash (+ (game-big game) (game-small game)) -1))

(defun guess-my-number ()
  (make-game))

(defun smaller (game)
  (set-game-big game (- (guess game) 1)))

(defun start-over ()
  (guess-my-number))