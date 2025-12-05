class CreateProductTopics < ActiveRecord::Migration[8.0]
  def change
    create_table :product_topics do |t|
      t.references :product, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
