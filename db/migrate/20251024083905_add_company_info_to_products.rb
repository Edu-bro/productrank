class AddCompanyInfoToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :company_name, :string
    add_column :products, :founded_year, :integer
    add_column :products, :headquarters, :string
    add_column :products, :employee_count, :string
  end
end
