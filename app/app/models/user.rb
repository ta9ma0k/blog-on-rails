class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable

  has_many :posts
  has_many :follows, dependent: :destroy
  has_many :followees, through: :follows

  validates :name, presence: true, format: { with: /\A[a-zA-Z]{1,20}\z/ }, length: { maximum: 20 }, uniqueness: true
  validates :email, presence: true, format: { with: Devise.email_regexp }, uniqueness: true
  validates :profile, length: { maximum: 200 }
  validates :blog_url, format: /\A#{URI::regexp(%w(http https))}\z/

  def post(body)
    new_post = posts.create(body:)
    new_post if new_post.valid?
  end

  def posted?(post) = post.user == self

  def follow?(user) = follows.map(&:followee_id).include?(user.id)

  def follow(user)
    return false if follow?(user)

    new_follow = follows.create(followee_id: user.id)
    new_follow.valid?
  end

  def unfollow(user)
    return false unless follow?(user)

    follow = follows.find_by(followee_id: user.id)
    follow.destroy
    follow.destroyed?
  end
end
