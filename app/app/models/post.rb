class Post < ApplicationRecord
  validates :body, presence: true, length: { maximum: 140 }

  alias_attribute :posted_at, :created_at

  scope :recently, -> { order(posted_at: :DESC).order(id: :DESC) }
end
