class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :restrict_with_exception
  has_many :comments, dependent: :restrict_with_exception

  has_one_attached :thumbnail do |attachable|
    attachable.variant :thumb, resize_to_fill: [150, 150, { crop: :centre }]
  end

  validates :body, presence: true, length: { maximum: 140 }

  alias_attribute :posted_at, :created_at

  scope :recently, -> { order(posted_at: :DESC).order(id: :DESC) }

  class << self
    def likes_ranking(date, limit = 10)
      date_range = date.all_day
      Like.group(:post).where(created_at: date_range).order(count_id: :desc).limit(limit).count(:id).keys
    end
  end
end
