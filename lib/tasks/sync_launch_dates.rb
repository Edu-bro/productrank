#!/usr/bin/env ruby
# Sync launch dates between Product and Launch models

puts '🔍 launch_date 불일치 확인 중...'

mismatched = 0
synced = 0

Product.joins(:launches).find_each do |product|
  product_date = product.launch_date
  launch_date = product.launches.first&.launch_date

  if product_date != launch_date
    mismatched += 1
    puts "  ❌ Product ##{product.id}: product.launch_date=#{product_date} vs launch.launch_date=#{launch_date}"

    # Product.launch_date가 NULL이면 Launch를 진실 공급원으로 사용
    # Product.launch_date가 있으면 그것을 우선 사용 (사용자가 직접 설정한 것)
    if product_date.present?
      product.launches.first.update!(launch_date: product_date)
      puts "    ✅ Launch 업데이트: #{product_date}"
    else
      # Launch 날짜는 유지 (이미 rake task로 설정됨)
      puts "    ℹ️  Launch 날짜 유지: #{launch_date}"
    end
    synced += 1
  end
end

puts "\n📊 결과:"
puts "  - 불일치 발견: #{mismatched}개"
puts "  - 동기화 완료: #{synced}개"
puts "✅ 2단계 완료: launch_date 동기화 완료"
