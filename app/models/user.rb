# frozen_string_literal: true

class User < ApplicationRecord
  has_many :microposts, dependent: :destroy

  # defines relationships where the user is following somebody else
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy

  # to get a list of who a user is following, user.following, this is achieved
  # via the source method
  has_many :following, through: :active_relationships, source: :followed

  # defines relationships where the user is followed by somebody else
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy

  # allows calling of user.followers via a join table
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: 50 }

  # original VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # full explanation @ https://www.railstutorial.org/book/modeling_users#table-valid_email_regex
  # rubular.com contains useful regex editing
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
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
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    # Same as password_digest == digest(token)
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Activates an account
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end

  # Sends password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
    # Reads as reset_sent_at '< earlier than' 2.hours.ago
  end

  def feed
    Micropost.where('user_id = ?', id)
  end

  # follows a user
  def follow(other_user)
    following << other_user
  end

  # unfollows another user
  def unfollow(other_user)
    following.delete(other_user)
  end

  # returns true if the current user is following the other user
  def following?(other_user)
    following.include?(other_user)
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
