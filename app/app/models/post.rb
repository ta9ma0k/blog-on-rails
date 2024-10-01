class Post < ApplicationRecord
  belongs_to :user
  has_many :likes
  has_many :comments

  validates :body, presence: true, length: { maximum: 140 }

  alias_attribute :posted_at, :created_at

  scope :recently, -> { order(posted_at: :DESC).order(id: :DESC) }
end
