class RemoveUrlFieldsFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :logo_url, :string
    remove_column :products, :cover_url, :string
    remove_column :products, :gallery_urls, :text
  end
end
