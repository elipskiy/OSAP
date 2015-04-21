(defun c:OSAP()
  (setq file nil)

  (OStartDialog)
)

(defun OStartDialog()
  (setq action nil)

  ; TODO: show skip when a file has been selected
  (initget 1 "Open Color Skip Exit")
  (setq action (getkword "Select an action [Open file/Color/Skip/Exit]\n"))

  (cond
    ((= action "Open") (progn
      (setq file (openFile))
      (ODialog)
    ))
    ((= action "Color") (OColorDialog))
    ((= action "Skip") (ODialog))
    ((= action "Exit") (exit))
  )
)

(defun ODialog()
  (setq t nil)

  (initget 1 "2d 3d")
  (setq t (getkword "Select type of figure [2d/3d]\n"))
  (cond
    ((= t "2d") (2dPart))
    ((= t "3d") (3dPart))
  )
)

(defun OColorDialog()
  (initdia)
  (command "color")

  (OStartDialog)
)

(defun openFile()
  (setq file nil)

  (setq file (getfiled "Open file" "" "txt" 0))
)

(defun skipExtraLine(part f)
  (setq l nil)

  (while (and (/= l (strcase part T)) (/= l "end"))
    (setq l (read-line f))
  )
)

(defun 2dPart()
  (setq part nil)

  (initget 1 "Duga Ellipse Poliliniya PYatiugol'nik")
  (setq part (getkword "Select a figure [Duga/Ellipse/Poliliniya/PYatiugol'nik]\n"))

  (setq f (open file "r"))
  (skipExtraLine part f)

  (cond
    ; Start point, end point, angle
    ((= part "Duga") (command "arc" (setq startPoint (getpoint)) "E" (duga) "A" angle))
    ; Start point, end point, distance
    ((= part "Ellipse") (command "ellipse" (setq startPoint (getpoint)) (ellipse) distance))
    ;
    ((= part "Poliliniya") (command "pline" (setq startPoint (getpoint)) (poliliniya)))
    ; Start point, radius
    ((= part "PYatiugol'nik") (command "polygon" 5 (getpoint) "I" (pyatiugolnik)))
  )

  (close f)
  (OStartDialog)
)

(defun duga()
  (setq relPoint (list (atof (read-line f)) (atof (read-line f))))
  (setq angle (read-line f))

  (mapcar '+ startPoint relPoint)
)

(defun ellipse()
  (setq relPoint (list (atof (read-line f)) (atof (read-line f))))
  (setq distance (read-line f))

  (mapcar '+ startPoint relPoint)
)

; polyline attached to other points
(defun poliliniya()
  (setq lX nil lY nil prevPoint startPoint)

  (while (and (and (/= lX "") (/= lX "end")) (and (/= lY "") (/= lY "end")))
    (setq lX (read-line f) lY (read-line f))
    (setq relPoint (list (atof lX) (atof lY)))
    (setq newPoint (mapcar '+ prevPoint relPoint))

    (command newPoint)
    (setq prevPoint newPoint)
  )
  (command "")
)

(defun pyatiugolnik()
  (setq radius nil)

  (setq radius (read-line f))
)

(defun 3dPart()
  (setq part nil)

  ;TODO: change shading mode when added support change of color

  (initget 1 "Tor Prisma Konus Shar")
  (setq part (getkword "Select a figure [Tor/Prisma/Konus/Shar]\n"))

  (setq f (open file "r"))
  (skipExtraLine part f)

  (cond
    ; Center point, radius, tube radius
    ((= part "Tor") (progn
      (tor)
      (command "torus" (getpoint) radius tubeRadius))
    )
  )

  (close f)
  (OStartDialog)
)

(defun tor()
  (setq radius (read-line f))
  (setq tubeRadius (read-line f))
)
