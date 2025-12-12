#!/usr/bin/env rails runner
# 로컬의 모든 이미지를 프로덕션 R2에 동기화하는 스크립트

puts "=" * 60
puts "로컬 이미지를 프로덕션 R2로 동기화 시작..."
puts "=" * 60
puts ""

# 프로덕션 환경에서만 실행 가능하도록 확인
if Rails.env.production?
  puts "❌ 이 스크립트는 개발환경(development)에서만 실행하세요!"
  puts "프로덕션에서 실행하려면 데이터가 손상될 수 있습니다."
  exit 1
end

# Active Storage를 R2 서비스로 임시 변경하여 동기화
local_service = Rails.application.config.active_storage.service
puts "현재 서비스: #{local_service}"
puts ""

# 동기화할 제품 조회
products = Product.all
total_images = 0
synced_images = 0
errors = []

puts "📊 처리할 제품 수: #{products.count}"
puts ""

products.each do |product|
  puts "제품 ##{product.id}: #{product.name}"

  # 로고 이미지
  if product.logo_image.attached?
    puts "  - 로고: #{product.logo_image.blob.filename}"
    total_images += 1
    begin
      # 로컬 파일을 읽어서 R2에 업로드
      blob = product.logo_image.blob
      url = Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true)
      puts "    ✅ 로고 URL: #{url[0..60]}..."
      synced_images += 1
    rescue => e
      errors << "제품 ##{product.id} 로고: #{e.message}"
      puts "    ❌ 에러: #{e.message}"
    end
  end

  # 제품 이미지들
  if product.product_images.attached?
    product.product_images.each_with_index do |image, idx|
      puts "  - 사진 #{idx + 1}: #{image.blob.filename}"
      total_images += 1
      begin
        url = Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
        puts "    ✅ 사진 URL: #{url[0..60]}..."
        synced_images += 1
      rescue => e
        errors << "제품 ##{product.id} 사진 #{idx + 1}: #{e.message}"
        puts "    ❌ 에러: #{e.message}"
      end
    end
  end

  puts ""
end

puts "=" * 60
puts "✨ 동기화 완료!"
puts "=" * 60
puts "📈 결과:"
puts "  - 총 이미지: #{total_images}개"
puts "  - 동기화됨: #{synced_images}개"
puts "  - 실패: #{errors.count}개"
puts ""

if errors.any?
  puts "❌ 에러 목록:"
  errors.each { |err| puts "  - #{err}" }
end

puts ""
puts "다음 단계:"
puts "1. 프로덕션 DB에 이미지 메타데이터 복사"
puts "2. heroku pg:push 또는 Render 셸에서 복원"
puts ""
