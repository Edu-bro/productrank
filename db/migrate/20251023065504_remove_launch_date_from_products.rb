class RemoveLaunchDateFromProducts < ActiveRecord::Migration[8.0]
  def up
    # 안전 체크: 모든 Product가 Launch를 가지는지 확인
    orphaned_count = Product.left_joins(:launches).where(launches: { id: nil }).count

    if orphaned_count > 0
      raise "Migration aborted: #{orphaned_count} products without launches. Run data cleanup first."
    end

    # launch_date 컬럼 제거
    remove_column :products, :launch_date, :datetime
  end

  def down
    # 롤백 시 컬럼 복원
    add_column :products, :launch_date, :datetime

    # Launch 데이터를 Product로 복사
    Product.reset_column_information
    Product.joins(:launches).find_each do |product|
      product.update_column(:launch_date, product.launches.first.launch_date)
    end
  end
end
