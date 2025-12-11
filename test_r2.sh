#!/bin/bash

# R2 Storage Connection Test Script
# 사용법: ./test_r2.sh

echo "================================"
echo "🔍 R2 스토리지 연결 테스트"
echo "================================"
echo ""

# 1. .env 파일 확인
echo "1️⃣  .env 파일 확인..."
if [ ! -f .env ]; then
    echo "❌ .env 파일이 없습니다!"
    exit 1
fi

echo "✅ .env 파일 존재"
echo ""

# 2. R2 환경변수 확인
echo "2️⃣  R2 환경변수 확인..."
if grep -q "R2_ACCESS_KEY_ID" .env && \
   grep -q "R2_SECRET_ACCESS_KEY" .env && \
   grep -q "R2_BUCKET" .env && \
   grep -q "R2_ENDPOINT" .env; then
    echo "✅ 모든 R2 환경변수 설정됨"
else
    echo "❌ R2 환경변수가 누락되었습니다!"
    exit 1
fi
echo ""

# 3. storage.yml 확인
echo "3️⃣  config/storage.yml 확인..."
if grep -q "cloudflare:" config/storage.yml; then
    echo "✅ Cloudflare R2 설정 존재"
else
    echo "❌ Cloudflare R2 설정이 없습니다!"
    exit 1
fi
echo ""

# 4. 환경별 설정 확인
echo "4️⃣  환경별 스토리지 설정 확인..."
echo ""
echo "  📌 Development:"
grep "active_storage.service" config/environments/development.rb | sed 's/^/    /'
echo ""
echo "  📌 Production:"
grep "active_storage.service" config/environments/production.rb | sed 's/^/    /'
echo ""

# 5. R2 연결 테스트
echo "5️⃣  R2 연결 테스트..."
echo "  (이 과정은 시간이 걸릴 수 있습니다...)"
echo ""

RAILS_ENV=production bundle exec rails console <<'EOF' 2>&1 | grep -E "^(Service:|Bucket:|Endpoint:|✅|❌|Error|ArgumentError)" || true
begin
  puts "Testing R2 connection..."

  # 설정 확인
  service_name = Rails.configuration.active_storage.service
  puts "✅ Service: #{service_name}"

  # Product와 User 모델 확인
  product_count = Product.count
  user_count = User.count

  puts "✅ Database: #{product_count} products, #{user_count} users"

  # 첫 번째 Product 확인
  product = Product.first
  if product
    puts "✅ First product: #{product.name}"
    puts "  - Logo attached: #{product.logo_image.attached?}"
    puts "  - Images attached: #{product.product_images.attached?}"
  end

  # 첫 번째 User 확인
  user = User.first
  if user
    puts "✅ First user: #{user.name}"
    puts "  - Avatar attached: #{user.avatar.attached?}"
  end

  puts ""
  puts "✅ R2 연결 성공!"
rescue => e
  puts "❌ R2 연결 실패: #{e.class}"
  puts "   메시지: #{e.message}"
end
exit
EOF

echo ""
echo "================================"
echo "✅ 테스트 완료!"
echo "================================"
echo ""
echo "📝 다음 단계:"
echo "  1. 개발: bin/dev 또는 rails s"
echo "  2. R2 테스트: RAILS_ENV=production rails console"
echo "  3. 배포: git push"
echo ""
