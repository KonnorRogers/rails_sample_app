# frozen_string_literal: true

class User < ApplicationRecord
  before_save { email.downcase! }

  validates :name, presence: true, length: { maximum: 50 }

  # original VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # full explanation @ https://www.railstutorial.org/book/modeling_users#table-valid_email_regex
  # rubular.com contains useful regex editing
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password # uses bcrypt
  validates :password, presence: true, length: { minimum: 6 }
end
