class ProductTopic < ApplicationRecord
  belongs_to :product
  belongs_to :topic
end
