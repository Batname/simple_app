class User < ActiveRecord::Base

  has_many :microposts, dependent: :destroy
  attr_accessible :name, :email, :password, :password_confirmation
  has_many :relationships,foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",class_name:  "Relationship", dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_create :create_remember_token




  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false}

  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end


  def feed
    Micropost.from_users_followed_by(self)
  end

  private

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end
end
