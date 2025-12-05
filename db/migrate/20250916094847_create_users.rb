class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :name
      t.integer :role
      t.integer :reputation
      t.text :bio
      t.string :avatar_url
      t.string :website
      t.string :github_url
      t.string :twitter_url

      t.timestamps
    end
    add_index :users, :username, unique: true
  end
end
