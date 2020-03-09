
(defvar *start-line* "NARROW_START")
(defvar *end-line* "NARROW_END")
(defvar error-from-autonarrow nil)

(defun auto-narrow (&optional start-line end-line)
  "Narrow the buffer to a region specified by the arguments.

    Searches from the start of the buffer for the string given by
    START-LINE, and the from the end of the buffer for the string
    given by END-LINE.  If it finds these strings, it will narrow
    the buffer to the region starting with the line after the line
    containing START-LINE, and ending with the line before the line
    containing END-LINE.  If anything looks off, autonarrow does
    nothing."
  (interactive)
  (when (not start-line)  (setf start-line *start-line*))
  (when (not end-line)    (setf end-line *end-line*))

  (cond
    ((not start-line) (when error-from-autonarrow
			(error (format "No start-line string"))))
    ((not end-line)   (when error-from-autonarrow
			(error (format "No end-line string"))))
    (t (let ((start-match (save-excursion
			    (goto-char (point-min))
			    (search-forward start-line nil t)))
	     (end-match (save-excursion
			  (goto-char (point-max))
			  (search-backward end-line nil t))))

	 (cond
	   ((not start-match)
	    (when error-from-autonarrow
	      (error (concat "Could not find starting string: " start-line))))
	   ((not end-match)
	    (when error-from-autonarrow
	      (error (concat "Could not find ending string: " end-line))))
	   ((>= start-match end-match)
	    (when error-from-autonarrow
	      (error (concat
		      (format "Starting point %d follows ending point %d"
			  start-match end-match)))))
	   
	   (t (let ((line-after-start (save-excursion
					(goto-char start-match)
					(forward-line)
					(line-beginning-position)))
		    (line-before-end (save-excursion
				       (goto-char end-match)
				       (line-beginning-position))))

		;; Make sure these points exists and are well-ordered,
		;; start before end
		(cond
		  ((not line-after-start)
		   (when error-from-autonarrow
		     (error (concat
			     "Error calculating start point of narrowing"))))
		  ((not line-before-end)
		   (when error-from-autonarrow
		     (error (concat
			     "Error calculating end point of narrowing"))))
		  ((< line-after-start line-before-end)
		   (narrow-to-region line-after-start line-before-end)
		   (message "Narrowed"))))))))))

