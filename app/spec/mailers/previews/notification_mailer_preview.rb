# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def commented
    post_user = User.build(name: 'postman', email: 'postman@example.com', blog_url: 'http://example.com')
    comment_user = User.build(name: 'commentman', email: 'commentman@example.com', blog_url: 'http://example.com')
    post = Post.build(body: "hello world", user: post_user)
    comment = Comment.build(post:, user: comment_user, body: "コメント")
    NotificationMailer.commented(comment)
  end
end
