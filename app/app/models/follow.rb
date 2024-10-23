class Follow < ApplicationRecord
  belongs_to :user
  belongs_to :followee, class_name: "User"

  validates :user, uniqueness: { scope: :followee }
end
