class AddUserToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :user, null: true, foreign_key: true
    
    # 기존 제품들에 첫 번째 사용자를 할당
    reversible do |dir|
      dir.up do
        first_user = User.first
        if first_user
          Product.update_all(user_id: first_user.id)
        end
      end
    end
    
    # null: false로 변경
    change_column_null :products, :user_id, false
  end
end
