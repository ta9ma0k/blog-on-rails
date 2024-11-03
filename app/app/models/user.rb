class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable

  has_many :posts, dependent: :restrict_with_exception
  has_many :follows, dependent: :restrict_with_exception
  has_many :followees, through: :follows
  has_many :followee_posts, through: :followees, source: :posts
  has_many :likes, dependent: :restrict_with_exception
  has_many :comments, dependent: :restrict_with_exception

  validates :name, presence: true, format: { with: /\A[a-zA-Z]{1,20}\z/ }, length: { maximum: 20 }, uniqueness: true
  validates :email, presence: true, format: { with: Devise.email_regexp }, uniqueness: true
  validates :profile, length: { maximum: 200 }
  validates :blog_url, format: /\A#{URI.regexp(%w[http https])}\z/, allow_blank: true

  def post(body, thumbnail = nil)
    new_post = posts.create(body:, thumbnail:)
    new_post if new_post.valid?
  end

  def posted?(post) = post.user == self

  def comment(post, body)
    new_comment = comments.create(post:, body:)
    return false if new_comment.invalid?

    NotificationMailer.commented(new_comment).deliver_now
    true
  end

  def like?(post)
    likes.exists?(post:)
  end

  def like(post)
    return false if like?(post)

    like = likes.build(post:)
    like.save
  end

  def unlike(post)
    return false unless like?(post)

    like = likes.find_by(post: post).destroy
    like.destroyed?
  end

  def follow?(followee)
    follows.exists?(followee:)
  end

  def follow(followee)
    return false if follow?(followee)

    follow = follows.build(followee:)
    follow.save
  end

  def unfollow(followee)
    return false unless follow?(followee)

    follow = follows.find_by(followee:).destroy
    follow.destroyed?
  end
end
