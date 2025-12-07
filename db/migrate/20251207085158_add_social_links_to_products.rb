class AddSocialLinksToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :facebook_url, :string
    add_column :products, :instagram_url, :string
    add_column :products, :tiktok_url, :string
    add_column :products, :github_url, :string
  end
end
