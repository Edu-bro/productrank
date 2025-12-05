class User < ApplicationRecord
  enum :role, { member: 0, maker: 1, moderator: 2, admin: 3 }

  # Active Storage for avatar
  has_one_attached :avatar

  has_many :maker_roles, dependent: :destroy
  has_many :made_products, through: :maker_roles, source: :product
  has_many :products, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_products, through: :likes, source: :product
  
  has_many :follows, foreign_key: :follower_id, dependent: :destroy
  has_many :followed_users, through: :follows, source: :followable, source_type: 'User'
  has_many :followed_topics, through: :follows, source: :followable, source_type: 'Topic'
  has_many :followed_products, through: :follows, source: :followable, source_type: 'Product'
  
  has_many :follower_relationships, class_name: 'Follow', foreign_key: :followable_id, dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower
  
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 20 }, allow_blank: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :reputation, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Generate username from name if not provided
  before_validation :generate_username, if: -> { username.blank? && name.present? }
  
  before_validation :set_defaults
  
  private

  def generate_username
    # Generate username from name: "John Doe" -> "john_doe_1234"
    base_username = name.parameterize(separator: '_')
    random_suffix = rand(1000..9999)
    self.username = "#{base_username}_#{random_suffix}"

    # Ensure uniqueness
    while User.exists?(username: self.username)
      random_suffix = rand(1000..9999)
      self.username = "#{base_username}_#{random_suffix}"
    end
  end

  def set_defaults
    self.reputation ||= 0
    self.role ||= :member
  end
end
