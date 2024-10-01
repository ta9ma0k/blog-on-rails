class NotificationMailer < ApplicationMailer
  def commented(comment)
    @post_body = comment.post.body
    @comment_body = comment.body
    @comment_user = comment.user_name
    mail to: comment.post.user.email, subject: "コメントされました！"
  end
end
