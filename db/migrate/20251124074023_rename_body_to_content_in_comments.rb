class RenameBodyToContentInComments < ActiveRecord::Migration[8.0]
  def change
    rename_column :comments, :body, :content
  end
end
