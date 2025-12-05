# 샘플 데이터 생성 가이드

## ⚠️ 중요: 런칭 날짜 설정 주의사항

### 문제 사례
```ruby
# ❌ 잘못된 예시 - 메인페이지에 노출 안 됨
launch_offset: -2  # 2일 전 (과거)
launch_date: Date.current - 2.days  # 2일 전 (과거)
```

**결과**: 제품이 생성되지만 메인페이지의 "오늘 신규 제품" 섹션에 나타나지 않음!

### 해결 방법
```ruby
# ✅ 올바른 예시 - 메인페이지에 노출됨
launch_date: Date.current  # 오늘!
launch_date: Date.today    # 오늘!
```

## 📅 메인페이지 섹션별 날짜 조건

### 1. 오늘 신규 제품
```ruby
# home_controller.rb:12
where('DATE(launches.launch_date) = ?', Date.current)
```
- **조건**: `launch_date == 오늘`
- **필요**: `launch_date: Date.current`

### 2. 어제 랭크보드
```ruby
# home_controller.rb:20
where('DATE(launches.launch_date) = ?', Date.current - 1.day)
```
- **조건**: `launch_date == 어제`
- **필요**: `launch_date: Date.current - 1.day`

### 3. 저번주 랭크보드
```ruby
# home_controller.rb:28
where('DATE(launches.launch_date) >= ? AND DATE(launches.launch_date) < ?',
      Date.current - 7.days, Date.current)
```
- **조건**: `최근 7일 내 (오늘 제외)`
- **범위**: `오늘 - 7일 ~ 어제`

### 4. 저번달 랭크보드
```ruby
# home_controller.rb:37
where('DATE(launches.launch_date) >= ? AND DATE(launches.launch_date) < ?',
      Date.current - 30.days, Date.current)
```
- **조건**: `최근 30일 내 (오늘 제외)`
- **범위**: `오늘 - 30일 ~ 어제`

## 🎯 올바른 샘플 데이터 생성 패턴

### 패턴 1: 오늘 제품 추가 (메인페이지 노출용)
```ruby
today = Date.current  # 항상 현재 날짜 사용

Product.create!(
  name: "New Product",
  # ... other fields ...
)

Launch.create!(
  product: product,
  launch_date: today,  # ✅ 오늘!
  region: 'kr',
  status: :live
)
```

### 패턴 2: 이번주/저번주 제품 추가
```ruby
today = Date.current

# 어제 제품
Launch.create!(launch_date: today - 1.day)  # 어제

# 이번주 제품
Launch.create!(launch_date: today - 2.days)  # 2일 전
Launch.create!(launch_date: today - 3.days)  # 3일 전
Launch.create!(launch_date: today - 6.days)  # 6일 전

# 저번주 제품
Launch.create!(launch_date: today - 7.days)  # 정확히 1주일 전
Launch.create!(launch_date: today - 10.days) # 10일 전
Launch.create!(launch_date: today - 13.days) # 13일 전
```

## 🚫 하지 말아야 할 것

### ❌ 절대값 사용 금지
```ruby
# ❌ 나쁜 예시 - 날짜가 고정됨
launch_date: Date.new(2025, 12, 1)  # 하드코딩된 날짜
launch_date: "2025-12-01"           # 문자열 날짜
```

### ❌ offset 변수 음수 사용 주의
```ruby
# ❌ 헷갈리는 패턴
launch_offset: -2  # 2일 전? 2일 후?

# ✅ 명확한 패턴
days_ago: 2  # 2일 전 (명확!)
launch_date: Date.current - 2.days  # 명확!
```

## 📋 체크리스트

샘플 데이터 생성 전 확인사항:

- [ ] `Date.current`를 사용했는가? (하드코딩된 날짜 아님)
- [ ] 오늘 제품을 추가하는가? → `launch_date: Date.current`
- [ ] 과거 제품인가? → `launch_date: Date.current - N.days`
- [ ] 날짜 변수명이 명확한가? (`days_ago`, `launch_date` 등)
- [ ] 캐시 클리어를 했는가? → `Rails.cache.clear`

## 🔍 디버깅

### 메인페이지에 제품이 안 보일 때
```ruby
# 1. 제품의 런칭 날짜 확인
product = Product.find_by(name: "Product Name")
launch = product.launches.first
puts "Launch date: #{launch.launch_date}"
puts "Today: #{Date.current}"
puts "Match? #{launch.launch_date.to_date == Date.current}"

# 2. 섹션별 쿼리 직접 실행
today_products = Product.published
  .joins(:launches)
  .where('DATE(launches.launch_date) = ?', Date.current)
puts "Today's products: #{today_products.count}"

# 3. 캐시 클리어
Rails.cache.clear
```

## 📚 참고 파일

- `db/add_today_products.rb` - 오늘 제품 추가 스크립트
- `db/fix_launch_dates.rb` - 날짜 수정 스크립트
- `app/controllers/home_controller.rb` - 메인페이지 쿼리 로직
- `app/views/home/index.html.erb` - 메인페이지 뷰 (캐시 사용 중)

## 🎉 성공 사례

2025-12-04 업데이트:
- ✅ 오늘 제품 3개 추가: NeuralWrite Pro, DataFlow Analytics, MoodTrack Wellness
- ✅ 모든 제품이 올바른 날짜로 설정됨
- ✅ 메인페이지 각 섹션에 정상 노출 확인
