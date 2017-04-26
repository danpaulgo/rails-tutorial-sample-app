class User < ApplicationRecord

  before_save do
    self.email.downcase!
  end

  validates :name, presence: true, length: {minimum: 2, maximum: 50}

  email_regex = /\A[\w+\-.]+@[a-zA-Z\d\-]+(\.[a-z\d\-]+)*\.[a-zA-Z]+\z/
  validates :email, presence: true, uniqueness: {case_sensitive: false}, length: {minimum: 2, maximum: 255}, format: {with: email_regex}

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}

end


