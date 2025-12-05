class DropLaunches < ActiveRecord::Migration[8.0]
  def up
    drop_table :launches
  end

  def down
    create_table :launches do |t|
      t.references :product, null: false, foreign_key: true
      t.datetime :launch_date
      t.integer :status
      t.string :region

      t.timestamps
    end
  end
end
