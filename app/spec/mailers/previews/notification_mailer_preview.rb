# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def initialize(args)
    super
    @user = User.build(name: 'postman', email: 'postman@example.com')
  end
  def commented
    comment_user = User.build(name: 'commentman', email: 'commentman@example.com')
    post = Post.build(body: "hello world", user: @user)
    comment = Comment.build(post:, user: comment_user, body: "コメント")
    NotificationMailer.commented(comment)
  end

  def ranking
    date = Date.new(2024, 10, 1)
    posts = 10.times.map { Post.build(body: "post#{_1}", user: @user) }
    NotificationMailer.ranking(@user, posts, date)
  end
end
