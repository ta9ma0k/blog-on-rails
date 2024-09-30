class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user, uniqueness: { scope: :post }

  delegate :name, to: :user, prefix: true
end
