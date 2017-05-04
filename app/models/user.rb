class User < ApplicationRecord

  attr_accessor :remember_token

  before_save do
    self.email.downcase!
  end

  validates :name, presence: true, length: {minimum: 2, maximum: 50}

  email_regex = /\A[\w+\-.]+@[a-zA-Z\d\-]+(\.[a-z\d\-]+)*\.[a-zA-Z]+\z/
  validates :email, presence: true, uniqueness: {case_sensitive: false}, length: {minimum: 2, maximum: 255}, format: {with: email_regex}

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions AND assigns remember_token to user instance
  def remember_token_digest
    self.remember_token = User.new_token
    # Updates remember_digest in database from nil to digest of remember_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the unhashed digest.
  def authenticated?(remember_token)
      BCrypt::Password.new(remember_digest).is_password?(remember_token) if remember_digest
  end

  def forget_digest
    update_attribute(:remember_digest, nil)
  end
end


