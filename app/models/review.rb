class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many :replies, dependent: :destroy
  
  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :content, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :user_id, uniqueness: { scope: :product_id, message: "이미 이 제품에 대한 리뷰를 작성했습니다." }
  
  scope :by_rating, ->(rating) { where(rating: rating) }
  scope :recent, -> { order(created_at: :desc) }
  scope :helpful, -> { order(helpful_count: :desc) }
  scope :with_user, -> { includes(:user) }
  
  def helpful?
    helpful_count > 0
  end
  
  def has_replies?
    reply_count > 0
  end
end
