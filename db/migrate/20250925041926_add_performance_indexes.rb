class AddPerformanceIndexes < ActiveRecord::Migration[8.0]
  def change
    # Composite index for product_topics to optimize category queries
    add_index :product_topics, [:topic_id, :product_id], name: 'idx_product_topics_topic_product'
    
    # Composite index for products status and created_at for filtering published products
    add_index :products, [:status, :created_at], name: 'idx_products_status_created'
    
    # Unique index on topics.slug for faster category lookups
    add_index :topics, :slug, unique: true, name: 'idx_topics_slug_unique'
  end
end
