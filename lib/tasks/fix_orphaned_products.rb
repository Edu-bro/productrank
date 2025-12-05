#!/usr/bin/env ruby
# Cleanup script for orphaned products

puts '🔍 고아 제품 확인 중...'
orphaned = Product.left_joins(:launches).where(launches: { id: nil })
puts "고아 제품 수: #{orphaned.count}"

orphaned.each do |product|
  puts "  - Product ##{product.id}: #{product.name}"
  puts "    launch_date: #{product.launch_date || 'NULL'}"

  # Launch 레코드 생성 (region 기본값 추가)
  launch = product.launches.create!(
    launch_date: product.launch_date || Time.current,
    status: product.status,
    region: 'kr'  # 기본 지역 설정
  )

  puts "    ✅ Launch 레코드 생성됨 (ID: #{launch.id}, date: #{launch.launch_date})"
end

puts "\n✅ 1단계 완료: 모든 제품에 Launch 레코드 생성됨"
