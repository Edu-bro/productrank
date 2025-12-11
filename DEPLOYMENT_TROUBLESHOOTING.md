# 🚀 배포 환경 문제 해결 가이드

## 📋 목차
1. [문제 진단](#문제-진단)
2. [일반적인 문제와 해결책](#일반적인-문제와-해결책)
3. [데이터 마이그레이션](#데이터-마이그레이션)
4. [이미지 문제 해결](#이미지-문제-해결)
5. [모니터링 및 유지보수](#모니터링-및-유지보수)

---

## 문제 진단

### 1단계: 환경 확인

```bash
# 배포 환경의 Rails 버전 및 상태
curl -s https://productrank.onrender.com/health

# 또는 Render 대시보드에서 확인:
# Logs → 최근 배포 로그 확인
```

### 2단계: 주요 문제 체크리스트

| 문제 | 확인 방법 |
|------|---------|
| 제품이 안 보임 | Render DB에 products 테이블 비어있는지 확인 |
| 이미지가 안 보임 | R2 버킷이 PUBLIC 설정되어 있는지 확인 |
| 500 오류 | Render 로그에서 에러 메시지 확인 |
| 느린 속도 | R2 연결 지연, DB 쿼리 성능 확인 |

---

## 일반적인 문제와 해결책

### ❌ 문제 1: 제품이 안 보임 (DB 데이터 없음)

**원인:**
- Development: SQLite3 (로컬 파일)
- Production: PostgreSQL (Render에서 제공)
- 두 DB가 완전히 분리되어 있음

**진단:**

```bash
# Render SSH 접속
# (Render Dashboard → Web Service → Connect → SSH)

# 데이터 확인
rails dbconsole
SELECT COUNT(*) FROM products;  # 0이면 데이터 없음
```

**해결책 1: Render에서 직접 시드 데이터 추가 (빠름)**

```bash
# Render에 SSH로 접속 후:
rails console
Product.create!(name: "Test Product", ...)
```

**해결책 2: 로컬 DB 데이터를 Render로 복사 (권장)**

```bash
# 로컬에서 현재 상태 확인
rails db:health_check

# 진단용 CSV 내보내기
rails db:export_csv

# Render로 수동 복사 (UI를 통해 CSV 업로드)
```

**해결책 3: 자동 마이그레이션 스크립트**

```bash
# 준비 중 - lib/tasks/db_sync.rake 참고
rails db:sync_to_production  # Development 환경에서만
```

---

### ❌ 문제 2: 이미지가 안 보임

**원인:**
```
주요 원인:
1. R2 버킷이 PRIVATE으로 설정됨
2. 환경변수 설정 오류 (R2_ACCESS_KEY_ID 등)
3. 이미지 URL이 잘못 생성됨 (only_path 문제)
```

**진단:**

```bash
# Render SSH 접속
rails console

# 이미지 정보 확인
product = Product.first
puts product.logo_image.attached?  # false면 이미지 데이터 없음
puts product.logo_image.blob.service_name  # "cloudflare" 확인

# 생성되는 URL 확인
puts product.logo_thumb_1x  # 절대 URL인지 확인
```

**해결책:**

```bash
# 1. R2 버킷 설정 확인
# Cloudflare → R2 → 버킷 선택 → Settings
# - Public access: ON
# - CORS: 활성화

# 2. 환경변수 확인 (Render Dashboard)
# Settings → Environment Variables
# - R2_ACCESS_KEY_ID
# - R2_SECRET_ACCESS_KEY
# - R2_BUCKET
# - R2_ENDPOINT

# 3. 이미지 URL 생성 확인
# app/models/product.rb의 image_helper 사용
# → 환경에 따라 자동으로 올바른 URL 생성됨
```

---

### ❌ 문제 3: 500 오류

**진단:**

```bash
# Render 로그 확인
# 1. Render Dashboard → Logs
# 2. 에러 메시지 확인

# 일반적인 에러:
# - "missing required option :name" → R2 설정 오류
# - "connection refused" → DB 연결 오류
# - "uninitialized constant" → Rails 로드 오류
```

**해결책:**

```bash
# Render에 SSH 접속
rails console

# 설정 확인
Rails.configuration.active_storage.service  # cloudflare 확인
puts ENV['DATABASE_URL']  # PostgreSQL URL 확인
```

---

## 데이터 마이그레이션

### 방법 1: 완전 자동화 (권장)

```bash
# 로컬 개발 환경에서:
# 1. 데이터 확인
rails db:health_check

# 2. CSV로 내보내기
rails db:export_csv

# 3. Render에서 수동으로 CSV 업로드
#    (Render UI 또는 API 사용)
```

### 방법 2: 수동 복사

```bash
# Step 1: 로컬 DB 백업
rails runner 'Rake::Task["db:export_csv"].invoke'

# Step 2: Render SSH 접속

# Step 3: PostgreSQL에 직접 CSV 가져오기
rails dbconsole < dump.sql
```

### 방법 3: seed.rb 활용

```ruby
# db/seeds.rb에 고정 데이터 추가
# Render 배포 시 자동으로 실행됨

Product.find_or_create_by!(name: "ProductRank") do |product|
  product.tagline = "..."
  product.description = "..."
end
```

---

## 이미지 문제 해결

### 이미지 URL 생성 로직

```ruby
# app/helpers/image_helper.rb 사용 (새로 추가됨)

# Development: 상대 경로
/rails/active_storage/blobs/...

# Production: 절대 URL (R2)
https://2c44e0849...r2.cloudflarestorage.com/uu/5p/...
```

### 체크리스트

- [ ] R2 버킷에 파일 저장됨 (Cloudflare Dashboard 확인)
- [ ] R2 버킷이 PUBLIC 설정 ✅
- [ ] environment별 only_path 설정 올바름 ✅
- [ ] CORS 설정 확인 ✅

---

## 모니터링 및 유지보수

### 정기 점검 (주 1회)

```bash
# Render SSH 접속 후:

# 1. DB 상태 확인
rails db:health_check

# 2. R2 연결 확인
rails runner 'puts "R2: #{Rails.configuration.active_storage.service}"'

# 3. 로그 확인
tail -100 log/production.log | grep -i error
```

### 에러 로깅 활성화

```ruby
# config/environments/production.rb
config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)
config.log_level = :debug  # 더 많은 정보 로깅
```

### 자동 알림 설정 (권장)

```bash
# Render Dashboard → Notifications
# 배포 실패, 오류 발생 시 이메일/Slack 알림
```

---

## 📊 문제 해결 플로우차트

```
이미지 안 보임?
├─ R2에 파일 있는가?
│  ├─ NO → Active Storage에 이미지 첨부 안 됨
│  │      → rails db:health_check 실행
│  │      → 스토리지 마이그레이션 필요
│  └─ YES ↓
├─ R2 버킷이 PUBLIC인가?
│  ├─ NO → Cloudflare 설정 변경 필요
│  └─ YES ↓
├─ 이미지 URL이 절대 URL인가?
│  ├─ NO → image_helper 사용 필요
│  └─ YES ✅ 정상
```

---

## 🔧 유용한 명령어

### 로컬에서
```bash
# DB 건강도 체크
rails db:health_check

# CSV 내보내기
rails db:export_csv

# 테스트
curl -s http://localhost:3003/products | head -20
```

### Render에서 (SSH 접속 후)
```bash
# 상태 확인
rails console
Product.count  # 제품 수
ActiveStorage::Blob.count  # 이미지 수

# 로그 확인
tail -f log/production.log

# DB 직접 확인
rails dbconsole
\dt  # 테이블 목록
SELECT COUNT(*) FROM products;
```

---

## 📚 관련 문서
- `STORAGE_GUIDE.md` - 스토리지 설정
- `R2_SETUP_SUMMARY.md` - R2 요약
- `lib/tasks/db_sync.rake` - DB 동기화 도구

---

## ✅ 최종 체크리스트

배포 후 확인 사항:

- [ ] Render 배포 완료 (로그에 에러 없음)
- [ ] productrank.onrender.com 접속 가능
- [ ] 제품 목록 보임
- [ ] 제품 로고 이미지 보임
- [ ] 제품 상세 페이지 이미지 보임
- [ ] R2에서 파일 확인 가능
- [ ] 새 제품 추가 가능
- [ ] 이미지 업로드 가능

모든 항목이 ✅ 이면 정상 배포!

