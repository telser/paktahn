(in-package :pak)

;; Right now, this data structure choice seems good but the choice of pkg-name for a key
;; could make extending the checksumming to files other than PKGBUILDs messy later.
(defvar *checksums* (make-hash-table :test #'equal)
  "Hash table containing checksums of PKGBUILDs.
The package names are the keys. The checksum byte arrays
are the values. Support will be added for non-PKGBUILD files later.")

(defun load-checksums ()
  (let ((checksum-file (config-file "checksums")))
    (when (probe-file checksum-file)
      (with-simple-lock (file checksum-file)
	(setf *checksums* (cl-store:restore file))))))

(defun save-checksums ()
  (with-simple-lock (file (config-file "checksums"))
    (cl-store:store *checksums* file)))

(defun compare-checksums (pkg-name)
  (let ((pkgbuild-md5 (md5sum-file "PKGBUILD"))
	(old-md5s (lookup-checksum pkg-name)))
    (cond ((not old-md5s)  ; if new PKGBUILD, ask the user to review it and add it to the checksum-db
	   (prompt-user-review "PKGBUILD")
	   (add-checksum pkg-name pkgbuild-md5))
	  ((and (new-checksum-p pkgbuild-md5 old-md5s) ; otherwise, compare its md5sum to that on record and prompt the user if necessary
		(ask-y/n "The PKGBUILD checksum doesn't match our records. Review the PKGBUILD?"))
	   (launch-editor "PKGBUILD")
	   (add-checksum pkg-name pkgbuild-md5)))))

(defun add-checksum (pkg-name checksum)
  (pushnew checksum (gethash pkg-name *checksums*) :test #'equalp))

(defun lookup-checksum (pkg-name)
  (gethash pkg-name *checksums*))

(defun new-checksum-p (new old)
  (not (member new old :test #'equalp)))

(defmacro with-simple-lock ((var filespec) &rest body)
  (let ((stream (gensym))
	(fd (gensym)))
    `(with-open-file (,stream ,filespec
			      :if-does-not-exist :create
			      :direction :output)
       (let ((,fd (sb-sys:fd-stream-fd ,stream))
	     (,var ,filespec))
	 (sb-posix:lockf ,fd sb-posix:f-lock 0)
	 ,@body
	 (sb-posix:lockf ,fd sb-posix:f-ulock 0)))))

