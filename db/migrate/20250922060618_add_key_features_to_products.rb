class AddKeyFeaturesToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :key_features, :text
  end
end
