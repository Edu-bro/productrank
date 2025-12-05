class Reply < ApplicationRecord
  belongs_to :user
  belongs_to :review
  
  validates :content, presence: true, length: { minimum: 5, maximum: 500 }
  
  scope :recent, -> { order(created_at: :desc) }
  scope :with_user, -> { includes(:user) }
  
  after_create :increment_review_reply_count
  after_destroy :decrement_review_reply_count
  
  private
  
  def increment_review_reply_count
    review.increment!(:reply_count)
  end
  
  def decrement_review_reply_count
    review.decrement!(:reply_count)
  end
end
