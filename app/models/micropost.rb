class Micropost < ApplicationRecord
  belongs_to :user

  # Automatically pulls from DB in descending order using a Proc (lambda)
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader # image upload

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  private

  # Validates the size of a picture
  def picture_size
    errors.add(:picture, 'should be less than 5MB') if picture.size > 5.megabytes
  end

end
