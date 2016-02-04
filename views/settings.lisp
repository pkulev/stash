(in-package :stash.views)

(define-view admin-settings-page (params)
  (str (header params))
  (:form :action "/admin/settings"
         :method  "post"
         (:input :type "submit" :name "delete-posts" :value "Delete all posts") (:br)
         (:input :type "submit" :name "delete-emply-posts" :value "Delete empty posts") (:br)
         (:input :type "submit" :name "just-redirect" :value "Just redirect me") (:br)
         (:input :type "submit" :name "do-nothing" :value "Nothing") (:br)))