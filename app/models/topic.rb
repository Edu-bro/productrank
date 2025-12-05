class Topic < ApplicationRecord
  has_many :product_topics, dependent: :destroy
  has_many :products, through: :product_topics
  has_many :follows, as: :followable, dependent: :destroy
  has_many :followers, through: :follows, source: :follower
  
  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 200 }
  
  scope :popular, -> { joins(:follows).group('topics.id').order('COUNT(follows.id) DESC') }
  
  def to_param
    slug
  end
end
