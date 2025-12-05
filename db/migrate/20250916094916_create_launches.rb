class CreateLaunches < ActiveRecord::Migration[8.0]
  def change
    create_table :launches do |t|
      t.references :product, null: false, foreign_key: true
      t.datetime :launch_date
      t.string :region
      t.integer :status
      t.datetime :scheduled_at

      t.timestamps
    end
  end
end
