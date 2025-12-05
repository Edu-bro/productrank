class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :tagline
      t.text :description
      t.string :website_url
      t.string :logo_url
      t.string :cover_url
      t.text :gallery_urls
      t.text :pricing_info
      t.integer :status
      t.boolean :featured

      t.timestamps
    end
    add_index :products, :name, unique: true
  end
end
