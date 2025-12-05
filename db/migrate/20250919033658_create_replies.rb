class CreateReplies < ActiveRecord::Migration[8.0]
  def change
    create_table :replies do |t|
      t.references :user, null: false, foreign_key: true
      t.references :review, null: false, foreign_key: true
      t.text :content, null: false

      t.timestamps
    end
    
    add_index :replies, [:review_id, :created_at]
    add_index :replies, [:user_id, :created_at]
  end
end
