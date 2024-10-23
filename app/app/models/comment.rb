class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: true, length: { maximum: 255 }

  delegate :name, to: :user, prefix: true
end
