(in-package :stash)

(defun make-login-controller (app)
  (lambda (params)
    (let ((login (request-param-value params "login"))
          (password (request-param-value params "password"))
          (user *user*) ; temporary. later will be queried from DB
          (session (ningle:context :session)))
      (if (and (string= (user-login user) login)
               (user-authorized-p password user))
          (progn
            (setf (gethash :authorized session) t)
            (setf (gethash :current-user session) user)
            (make-response 302 '(:location "/")))
          (make-response 302 '(:location "/login"))))))

(defun make-logout-controller (app)
  (lambda (params)
    (let ((s (ningle:context :session)))
      (remhash :authorized s))
    (make-response 302 '(:location "/"))))

(defmacro logged-in-only (view-renderer &key redirect-function)
  (let ((redirect-function (or redirect-function
                               (lambda ()
                                 (make-response 404)))))
    `(lambda (params)
       (if (not (gethash :authorized (ningle:context :session) nil))
           (funcall ,redirect-function)
           (funcall ,view-renderer params)))))

(defun make-new-post-controller (app)
  (lambda (params)
    (let ((body (request-param-value params "post-body"))
          (caption (request-param-value params "post-caption"))
          (user-id (if (gethash :current-user (ningle:context :session))
                       (mongo-id (gethash :current-user (ningle:context :session)))
                       "0")))
      (with-database (db "stash")
        (store (make-instance 'post
                              :author-id user-id
                              :caption caption
                              :body body)
               db)))
    (make-response 302 '(:location "/posts"))))
