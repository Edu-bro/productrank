class MakerRole < ApplicationRecord
  belongs_to :user
  belongs_to :product
  
  validates :role, presence: true
  validates :user_id, uniqueness: { scope: :product_id }
end
