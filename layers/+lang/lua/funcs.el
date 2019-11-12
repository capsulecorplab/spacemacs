;;; funcs.el --- Lua Layer functions File for Spacemacs
;;
;; Copyright (c) 2012-2019 Sylvain Benner & Contributors
;;
;; Author: Lin Sun <sunlin7@yahoo.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defun spacemacs//lua-backend ()
  "Returns selected backend."
  (or lua-backend
      (cond
       ((configuration-layer/layer-used-p 'lsp) 'lsp-emmy))))

(defun spacemacs//lua-setup-backend ()
  "Conditionally setup lua backend."
  (setq lua-indent-level 2
        lua-indent-string-contents t)
  (spacemacs/set-leader-keys-for-major-mode 'lua-mode
    "hd" 'lua-search-documentation
    "sb" 'lua-send-buffer
    "sf" 'lua-send-defun
    "sl" 'lua-send-current-line
    "sr" 'lua-send-region
    "is" 'lua-show-process-buffer
    "ih" 'lua-hide-process-buffer)

  (pcase (spacemacs//lua-backend)
    (`lsp-emmy (spacemacs//lua-setup-lsp-emmy))))

(defun spacemacs//lua-setup-company ()
  "Conditionally setup company based on backend."
  (pcase (spacemacs//lua-backend)
    (`lsp-emmy (spacemacs//lua-setup-lsp-company))
    (_ (company-mode))))

(defun spacemacs//lua-setup-dap ()
  "Conditionally setup elixir DAP integration."
  ;; currently DAP is only available using LSP
  (pcase (spacemacs//lua-backend)
    (`lsp-emmy (spacemacs//lua-setup-lsp-dap))))

(defun spacemacs//lua-setup-flycheck ()
  "Conditionally setup flycheck based on backend."
  (pcase (spacemacs//lua-backend)
    (`lsp-emmy (spacemacs//lua-setup-lsp-flycheck))))


;; LSP Lua
(defun spacemacs//lua-setup-lsp-emmy ()
  "Setup LSP Lua."
  (if (not (configuration-layer/layer-used-p 'lsp))
      (message "`lsp' layer is not installed, please add `lsp' layer to your dotfile.")

    (require 'lsp-clients)
    (when lua-lsp-emmy-java-path
      (setq lsp-clients-emmy-lua-java-path lua-lsp-emmy-java-path))
    (when lua-lsp-emmy-jar-path
      (setq lsp-clients-emmy-lua-jar-path (expand-file-name lua-lsp-emmy-jar-path)))
    (setq lsp-enable-file-watchers lua-lsp-emmy-enable-file-watchers)

    (lsp)))

(defun spacemacs//lua-setup-lsp-company ()
  "Setup lsp auto-completion."
  (spacemacs|add-company-backends
    :backends company-lsp
    :modes lua-mode
    :append-hooks nil
    :call-hooks t)
  ;; TODO: disable the cache
  ;; (add-to-list 'company-lsp-filter-candidates '(emmy-lua . t))
  (company-mode))

(defun spacemacs//lua-setup-lsp-dap ()
  "Setup DAP integration."
  )                                     ; TODO: Lua Debug Adapter Protocol

(defun spacemacs//lua-setup-lsp-flycheck ()
  "Setup LSP Lua syntax checking."
  (if (configuration-layer/layer-used-p 'lsp)
      (when (spacemacs/enable-flycheck 'lua-mode)
        (lsp-ui-flycheck-enable nil)
        (flycheck-mode))
    (message "`lsp' layer is not installed, please add `lsp' layer to your dotfile.")))


