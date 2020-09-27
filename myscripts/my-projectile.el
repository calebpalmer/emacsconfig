;;; Run init.el when switching to a projectile project.
(defun cap/projectile-run-init ()
  (if
      (file-exists-p (concat projectile-project-root "/proj.el"))
      (load-file concat projectile-project-root "/proj.el"))
  )
(add-hook 'projectile-after-switch-project-hook 'cap/projectile-run-init)
