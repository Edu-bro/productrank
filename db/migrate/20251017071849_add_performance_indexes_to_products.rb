class AddPerformanceIndexesToProducts < ActiveRecord::Migration[8.0]
  def change
    # Performance indexes for common query patterns
    
    # Index for sorting by popularity (votes_count + likes_count * 2)
    add_index :products, [:status, :votes_count, :likes_count], name: 'idx_products_popularity'
    
    # Index for status + created_at queries (trending, recent)
    add_index :products, [:status, :created_at], name: 'idx_products_status_created_optimized' unless index_exists?(:products, [:status, :created_at])
    
    # Index for product_topics queries (category filtering)
    add_index :product_topics, [:topic_id, :product_id], name: 'idx_product_topics_lookup' unless index_exists?(:product_topics, [:topic_id, :product_id])
    
    # Index for user products
    add_index :products, :user_id unless index_exists?(:products, :user_id)
    
    # Index for votes queries
    add_index :votes, [:product_id, :user_id], name: 'idx_votes_product_user' unless index_exists?(:votes, [:product_id, :user_id])
  end
end
