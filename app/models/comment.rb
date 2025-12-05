class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :product, counter_cache: :comments_count
  belongs_to :parent, class_name: 'Comment', optional: true

  has_many :replies, class_name: 'Comment', foreign_key: :parent_id, dependent: :destroy

  # Alias: DB column is 'content' but we use 'body' for consistency
  alias_attribute :body, :content

  validates :body, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :upvotes, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  scope :top_level, -> { where(parent_id: nil) }
  scope :recent, -> { order(created_at: :desc) }
  scope :popular, -> { order(upvotes: :desc) }
  
  before_validation :set_defaults
  after_create :clear_product_caches
  after_destroy :clear_product_caches
  
  def reply?
    parent_id.present?
  end
  
  private
  
  def set_defaults
    self.upvotes ||= 0
  end
  
  def clear_product_caches
    Rails.cache.delete("comment_count_#{product_id}")
  end
end
