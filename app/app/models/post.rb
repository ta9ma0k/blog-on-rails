class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :restrict_with_exception
  has_many :comments, dependent: :restrict_with_exception

  has_one_attached :thumbnail do |attachable|
    attachable.variant :thumb, resize_to_limit: [150, 150]
  end

  validates :body, presence: true, length: { maximum: 140 }

  alias_attribute :posted_at, :created_at

  scope :recently, -> { order(posted_at: :DESC).order(id: :DESC) }

  class << self
    def likes_ranking(date, limit = 10)
      date_range = date.beginning_of_day..date.end_of_day
      select("posts.*, COUNT(likes.id) AS likes_count")
        .left_joins(:likes)
        .where(likes: { created_at: date_range })
        .group("posts.id")
        .order("likes_count DESC")
        .limit(limit)
    end
  end
end
