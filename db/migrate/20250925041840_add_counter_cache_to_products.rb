class AddCounterCacheToProducts < ActiveRecord::Migration[8.0]
  def change
    # Counter cache columns with default 0 and null: false for performance
    add_column :products, :votes_count, :integer, null: false, default: 0
    add_index :products, :votes_count
    add_column :products, :likes_count, :integer, null: false, default: 0
    add_index :products, :likes_count
    add_column :products, :comments_count, :integer, null: false, default: 0
    add_index :products, :comments_count
  end
end
