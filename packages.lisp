(in-package :cl-user)

(defpackage :stash.utils
  (:use :cl)
  (:export :string->hash
           :format-hash
           :format-value
           :current-file-location
           :request-param-value
           :make-response
           :escape-string))

(defpackage :stash.model
  (:use :cl :stash.utils)
  (:shadow :remove
           :find)
  (:export :with-database
           :with-collection
           :with-database-and-collection
           :store
           :remove
           :find
           :mongo-id
           :all-collection

           :user
           :user-login
           :user-password
           :user-authorized-p

           :post
           :markdown->html

           :paste

           :config
           :static-path
           :root-path

           :read-config-file
           :config-development-p
           :load-config-from-file

           :post))

(defpackage :stash.views
  (:use :cl
        :cl-who
        :stash.model
        :stash.utils
        :parenscript)
  (:shadowing-import-from :stash.model
                          :remove
                          :find)
  (:shadowing-import-from :stash.utils
                          :escape-string)
  (:export :generate-general-css))

(defpackage :stash
  (:use :cl
        :anaphora
        :stash.utils
        :stash.views
        :stash.model)
  (:shadowing-import-from :stash.model
                          :remove
                          :find)
  (:export :start
           :start-server
           :stop-server
           :deploy))
