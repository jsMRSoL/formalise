;;; sp-form-funcs.el --- Functions for fields I wont be writing again  -*- lexical-binding: t -*-

;; To use the functions in this utilty package, implement the following:
;;
;; (defun some-field-complete ()
;;   "Prompt for a value with completing-read and replace field contents."
;;   (interactive)
;;   (let* ((field-bounds (sp/get-field-bounds 'some-field))
;; 	 (value (completing-read "Choose: " '("bayer" "none")))
;; 	 (start (car field-bounds))
;; 	 (end (cdr field-bounds))
;; 	 (length (- end start)))
;;     (goto-char start)
;;     (insert value)
;;     (sp/define-field (cons start (point)) 'some-field some-field-keymap)
;;     (kill-line nil)))
;;
;; (defvar some-field-keymap
;;   (let ((map (make-sparse-keymap)))
;;     ;; Enter (RET) triggers the completing-read function
;;     (define-key map (kbd "RET") 'some-field-complete)
;;     map)
;;   "Keymap active when cursor is in a some-field.")

(defun sp/define-field (bounds field-sym keymap)
  "Make region START to END a field with RET keymap."
  (let ((start (car bounds))
	(end   (cdr bounds)))
    (put-text-property start end field-sym t)
    (put-text-property start end 'keymap keymap)
    (put-text-property start end 'read-only nil)
    (put-text-property start end 'face 'highlight)))


(defun sp/get-field-bounds (field-sym)
  "Return (START . END) of the field under point, or nil."
  (interactive)
  (let ((start (previous-single-property-change (point) field-sym))
        (end (next-single-property-change (point) field-sym)))
    (when (get-text-property (point) field-sym)
      (cons (or start (point-min))
            (or end (point-max))))))

(defun sp/set-rgx-range-readonly (rgx)
    (let* ((bounds (sp/find-regex-bounds rgx))
	   (start (car bounds))
	   (end (cdr bounds)))
      (put-text-property start end 'read-only t)))

(defun txt/insert-sp-text-comment (txt)
  "Insert text propertized with the `font-lock-comment-face'"
  (insert (propertize txt 'face 'font-lock-comment-face)))

(defun txt/insert-sp-labelled-line (elems fmt-str)
  (dolist (pair elems)
    (let ((key (car pair))
	  (value (cdr pair)))
      (insert
       (propertize (format fmt-str key) 'face 'font-lock-keyword-face)
       (propertize value 'face 'font-lock-string-face)
       "\n"))))

(provide 'sp-form-funcs)

;;; sp-form-funcs.el ends here
