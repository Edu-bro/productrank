class AddProfileFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    # Only add linkedin_url since other fields already exist
    add_column :users, :linkedin_url, :string
  end
end
