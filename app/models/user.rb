class User < ApplicationRecord

  attr_accessor :remember_token, :activation_token, :reset_token

  before_create :create_activation_digest
  before_save :downcase_email
  # before_save do
  #   self.email.downcase!
  # end

  has_many :microposts, dependent: :destroy
  # Since there is no "user_id" column, we must set the foreign key to "follower_id" since that is the column used to represent this user
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # Each column where this user is represented by the "follower_id", the user whos id corresponds to "followed_id" will be added to the users "following" collection
  has_many :following, through: :active_relationships, source: :followed
  # To create a followers collection, we reverse the above two methods as follows
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships
  # source: :follower_id is not necessary. Since the collection is names "followers", active_record will automatically user the column "follower_id" to join the users table. The association between follower_id and users is defined in the relationship model 

  # FOLLOWERS
  # SELECT follower_id FROM relationships
  # WHERE followed_id = self.id

  validates :name, presence: true, length: {minimum: 2, maximum: 50}

  email_regex = /\A[\w+\-.]+@[a-zA-Z\d\-]+(\.[a-z\d\-]+)*\.[a-zA-Z]+\z/
  validates :email, presence: true, uniqueness: {case_sensitive: false}, length: {minimum: 2, maximum: 255}, format: {with: email_regex}

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

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
  def authenticated?(attribute, token)
      digest = send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
  end

  def forget_digest
    update_attribute(:remember_digest, nil)
  end

  def activate
    self.update_attributes(activated: true, activated_at: Time.zone.now)
  end 

  def create_reset_digest
    self.reset_token = User.new_token
    digest = User.digest(reset_token)
    self.update_attributes(reset_digest: digest, reset_sent_at: Time.zone.now)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    sql = "user_id IN (#{following_ids}) OR user_id= :user_id"
    Micropost.where(sql, user_id: id)
    # self.microposts does not work since array must be returned in the form of ActiveRecord object for paginate to work properly
  end

  def following?(user)
    self.following.include?(user)
  end

  def follow(user)
    Relationship.create!(follower_id: id, followed_id: user.id) if !self.following?(user)
    # self.active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    relationship = Relationship.find_by(follower_id: id, followed_id: user.id)
    # relationship = self.active_relationships.find_by(followed_id: user.id)
    relationship.destroy if relationship
  end

  private

    def downcase_email
      self.email.downcase!
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(self.activation_token)
    end

end


