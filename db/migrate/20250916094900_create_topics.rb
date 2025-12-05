class CreateTopics < ActiveRecord::Migration[8.0]
  def change
    create_table :topics do |t|
      t.string :slug
      t.string :name
      t.text :description
      t.string :cover_url
      t.string :color

      t.timestamps
    end
    add_index :topics, :slug, unique: true
  end
end
