class AddLaunchDateToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :launch_date, :datetime
  end
end
