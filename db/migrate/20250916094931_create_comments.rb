class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :parent, null: true, foreign_key: { to_table: :comments }
      t.text :body
      t.integer :upvotes

      t.timestamps
    end
  end
end
