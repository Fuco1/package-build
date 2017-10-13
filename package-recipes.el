;;; package-recipes.el --- Tools for assembling a package archive

;; Copyright (C) 2017  Jonas Bernoulli

;; Author: Jonas Bernoulli <jonas@bernoul.li>

;; This file is not (yet) part of GNU Emacs.
;; However, it is distributed under the same license.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;; Code:
;;; Classes

(defclass package-recipe ()
  ((url-format      :allocation :class       :initform nil)
   (repopage-format :allocation :class       :initform nil)
   (tag-regexp      :allocation :class       :initform nil)
   (stable-p        :allocation :class       :initform t)
   (name            :initarg :name           :initform nil)
   (url             :initarg :url            :initform nil)
   (dir             :initarg :dir            :initform nil) ; WIP
   (repo            :initarg :repo           :initform nil)
   ;; (upstream-user   :initarg :upstream-user  :initform nil)
   ;; (upstream-name   :initarg :upstream-name  :initform nil)
   (repopage        :initarg :repopage       :initform nil)
   (files           :initarg :files          :initform nil)
   (branch          :initarg :branch         :initform nil)
   (commit          :initarg :commit         :initform nil)
   (module          :initarg :module         :initform nil)
   (version-regexp  :initarg :version-regexp :initform nil)
   (old-names       :initarg :old-names      :initform nil)
   )
  :abstract t)

(defmethod package-build--working-dir ((rcp package-recipe))
  (file-name-as-directory
   (expand-file-name (oref rcp name) package-build-working-dir)))

;;;; Git

(defclass package-git-recipe (package-recipe)
    (tag-regexp     :initform "\
\\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\} \
[0-9]\\{2\\}:[0-9]\\{2\\}:[0-9]\\{2\\}\\( [+-][0-9]\\{4\\}\\)?\\)"))))

(defclass package-github-recipe (package-git-recipe)
  ((url-format      :initform "https://github.com/%u/%n.git")
   (repopage-format :initform "https://github.com/%u/%n")))

(defclass package-gitlab-recipe (package-git-recipe)
  ((url-format      :initform "https://gitlab.com/%u/%n.git")
   (repopage-format :initform "https://gitlab.com/%u/%n")))

;;;; Mercurial

(defclass package-hg-recipe (package-recipe)
  ((tag-regexp      :initform "\
\\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\} \
[0-9]\\{2\\}:[0-9]\\{2\\}\\( [+-][0-9]\\{4\\}\\)?\\)")))

(defclass package-bitbucket-recipe (package-hg-recipe)
  ((url-format      :initform "https://bitbucket.com/%u/%n")
   (repopage-format :initform "https://bitbucket.org/%u/%n")))

;;;; Contemporary

(defclass package-bzr-recipe (package-recipe)
  ((tag-regexp      :initform  "\
\\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\} \
[0-9]\\{2\\}:[0-9]\\{2\\}:[0-9]\\{2\\}\\( [+-][0-9]\\{4\\}\\)?\\)")))

(defclass package-darcs-recipe (package-recipe)
  ((tag-regexp      :initform "\
\\([a-zA-Z]\\{3\\} [a-zA-Z]\\{3\\} \
\\( \\|[0-9]\\)[0-9] [0-9]\\{2\\}:[0-9]\\{2\\}:[0-9]\\{2\\} \
[A-Za-z]\\{3\\} [0-9]\\{4\\}\\)")))

(defclass package-fossil-recipe (package-recipe)
  ((tag-regexp       :initform "\
=== \\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\} ===\n\
[0-9]\\{2\\}:[0-9]\\{2\\}:[0-9]\\{2\\}\\) ")))

;;;; Legacy

(defclass package-cvs-recipe (package-recipe)
  ())

(defclass package-svn-recipe (package-recipe)
  ((tag-regexp      :initform "\
Last Changed Date: \\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\} \
[0-9]\\{2\\}:[0-9]\\{2\\}:[0-9]\\{2\\}\\( [+-][0-9]\\{4\\}\\)?\\)")))))

(defclass package-wiki-recipe (package-recipe)
  ((url-format      :initform "git@github:emacsmirror/emacswiki.org.git")
   (repopage-format :initform "https://github.com/emacsmirror/emacswiki.org")))

;; Local Variables:
;; coding: utf-8
;; checkdoc-minor-mode: 1
;; indent-tabs-mode: nil
;; End:
;;; package-build.el ends here
