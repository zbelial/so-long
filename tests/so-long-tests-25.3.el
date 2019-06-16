;;; so-long-tests.el --- Test suite for so-long.el  -*- lexical-binding: t; -*-

;; Running the tests with "make lisp/so-long-tests" is like:
;;
;; HOME=/nonexistent EMACSLOADPATH= LC_ALL=C \
;; EMACS_TEST_DIRECTORY=/home/phil/emacs/trunk/repository/test \
;; "../src/emacs" --no-init-file --no-site-file --no-site-lisp \
;; -L ":." -l ert -l lisp/so-long-tests.el --batch --eval \
;; '(ert-run-tests-batch-and-exit (quote (not (tag :unstable))))'
;;
;; See also `ert-run-tests-batch-and-exit'.

;;; Code:

(require 'ert)
(require 'so-long)
(load (expand-file-name "so-long-tests-helpers"
                        (file-name-directory (or load-file-name
                                                 default-directory))))

(declare-function so-long-tests-remember "so-long-tests-helpers")
(declare-function so-long-tests-assert-active "so-long-tests-helpers")
(declare-function so-long-tests-assert-reverted "so-long-tests-helpers")

;; Enable the automated behaviour for all tests.
(global-so-long-mode 1)

(ert-deftest so-long-tests-file-local-so-long-mode-long-form ()
  "File-local mode (long form). -*- mode: so-long -*-"
  (let
      ((orig so-long-file-local-mode-function))
    (setq-default so-long-file-local-mode-function 'so-long-mode-downgrade)
    (with-temp-buffer
      (insert ";; -*- mode: so-long -*-\n")
      (insert
       (make-string
	(1+ so-long-threshold)
	120))
      (normal-mode)
      (so-long-tests-assert-active 'so-long-mode)
      (so-long-revert)
      (so-long-tests-assert-reverted 'so-long-mode))
    (setq-default so-long-file-local-mode-function nil)
    (with-temp-buffer
      (insert ";; -*- mode: so-long -*-\n")
      (insert
       (make-string
	(1+ so-long-threshold)
	120))
      (normal-mode)
      (so-long-tests-assert-active 'so-long-mode)
      (so-long-revert)
      (so-long-tests-assert-reverted 'so-long-mode))
    (setq-default so-long-file-local-mode-function orig)))

;;; so-long-tests.el ends here
