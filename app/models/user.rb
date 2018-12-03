# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email
  before_create :create_activation_digest

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

  has_secure_password # uses bcrypt, checks for nil so we dont have to validate

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Methods

  # Creates a hashed cookie
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Creates a secure token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # remembers a user
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # authenticates
  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  private

  # converts emails to lowercase
  def downcase_email
    email.downcase!
  end

  # Creates and assigns the activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token # create token
    self.activation_digest = User.digest(activation_token) # hash the token
  end
end
