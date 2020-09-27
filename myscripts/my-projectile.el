;;; Run init.el when switching to a projectile project.
(defun cap/projectile-run-init ()
  (if
      (file-exists-p (concat (projectile-ensure-project (projectile-project-root)) "proj.el"))
      (progn
	(load-file (concat (projectile-ensure-project (projectile-project-root)) "proj.el")))
    )
  )
(add-hook 'projectile-after-switch-project-hook 'cap/projectile-run-init)
