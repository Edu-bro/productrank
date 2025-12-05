class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :product, counter_cache: :votes_count
  
  validates :user_id, uniqueness: { scope: :product_id }
  validates :weight, presence: true, inclusion: { in: [1] }
  
  before_validation :set_defaults
  after_create :clear_product_caches
  after_destroy :clear_product_caches
  
  private
  
  def set_defaults
    self.weight ||= 1
  end
  
  def clear_product_caches
    Rails.cache.delete("vote_count_#{product_id}")
    Rails.cache.delete("weekly_rank_#{product_id}")
    Rails.cache.delete("monthly_rank_#{product_id}")
  end
end
