(defun c:OSAP() 
  (ODialog)
)

(defun ODialog()
  (setq t nil)
      
  (initget 1 "2d 3d")
  (setq t (getkword "Select type of figure[2d/3d]\n"))
  (cond 
    ((= t "2d") (2dPart))  
    ((= t "3d") (3dPart))
  )
)

(defun 2dPart()
  (setq part nil)

  (initget 1 "Duga Ellipse Poliliniya PYatiugol'nik")
  (setq part (getkword "Select a figure[Duga/Ellipse/Poliliniya/PYatiugol'nik]\n"))

)

(defun 3dPart()
  (setq part nil)

  ;TODO: change shading mode when added support change of color

  (initget 1 "Tor Prisma Konus Shar")
  (setq part (getkword "Select a figure[Tor/Prisma/Konus/Shar]\n"))

)
