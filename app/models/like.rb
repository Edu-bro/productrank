class Like < ApplicationRecord
  belongs_to :user
  belongs_to :product, counter_cache: :likes_count
  
  validates :user_id, uniqueness: { scope: :product_id }
end
