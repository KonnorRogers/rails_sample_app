class Micropost < ApplicationRecord
  belongs_to :user

  # Automatically pulls from DB in descending order using a Proc (lambda)
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
