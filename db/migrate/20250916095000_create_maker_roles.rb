class CreateMakerRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :maker_roles do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
