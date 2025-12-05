class AddCompanyDescriptionToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :company_description, :text
  end
end
