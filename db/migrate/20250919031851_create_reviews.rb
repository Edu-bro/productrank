class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :content, null: false
      t.integer :helpful_count, default: 0
      t.integer :reply_count, default: 0

      t.timestamps
    end
    
    add_index :reviews, [:product_id, :created_at]
    add_index :reviews, [:user_id, :created_at]
    add_index :reviews, :rating
  end
end
