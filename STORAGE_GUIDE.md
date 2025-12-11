# ProductRank 스토리지 환경 설정 가이드

## 📋 현재 설정 상태

### 각 환경별 스토리지 서비스
| 환경 | 서비스 | 위치 | 용도 |
|------|--------|------|------|
| **development** | `:local` (로컬 디스크) | `storage/` 디렉토리 | 빠른 개발, 로컬 테스트 |
| **production** | `:cloudflare` (R2) | Cloudflare R2 버킷 | 실제 배포 환경 |

### 파일 위치
- **개발 환경 설정**: `config/environments/development.rb` (Line 36)
- **배포 환경 설정**: `config/environments/production.rb` (Line 25)
- **스토리지 정의**: `config/storage.yml`
- **R2 크리덴셜**: `.env` 파일

---

## 🔧 환경별 사용 방법

### 1️⃣ 개발 환경 (권장: 로컬 스토리지)

```bash
# 일반적인 개발 시작
bin/dev
# 또는
rails s
```

**특징:**
- ✅ 빠른 개발 속도 (네트워크 없음)
- ✅ 로컬 파일 접근 가능 (`storage/` 폴더)
- ✅ R2 비용 없음
- ✅ 크리덴셜 노출 위험 없음

**이미지 저장 위치**: `/storage/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/`

---

### 2️⃣ R2 테스트 (프로덕션 환경 시뮬레이션)

**필요한 경우만 사용:**
- 배포 전 최종 테스트
- R2 연결 문제 디버깅
- 프로덕션과 동일한 환경에서 이미지 처리 테스트

#### 방법 A: Rails Console에서 R2 테스트
```bash
# Production 환경으로 콘솔 실행
RAILS_ENV=production bundle exec rails console

# 콘솔에서 테스트
product = Product.first
puts product.logo_image.attached?
puts product.logo_image.blob.key
```

#### 방법 B: Rails 서버를 Production 모드로 실행
```bash
RAILS_ENV=production bundle exec rails s
```

**주의사항:**
- ⚠️ R2 크리덴셜이 올바르게 설정되어야 함 (.env 파일 확인)
- ⚠️ 매번 API 호출로 비용 발생 가능
- ⚠️ 인터넷 연결 필요
- ⚠️ 완료 후 반드시 종료

---

## 📊 이미지 저장 구조

### Active Storage 메커니즘
Rails는 **데이터베이스**를 통해 모든 이미지를 관리합니다:

```
데이터베이스 (SQLite/MySQL)
├── active_storage_blobs
│   ├── key: "xxxxxxxx" (R2에서의 파일 경로)
│   ├── filename: "logo.png"
│   ├── service_name: "cloudflare" 또는 "local"
│   └── content_type: "image/png"
│
└── active_storage_attachments
    ├── record_type: "Product"
    ├── record_id: 1
    ├── name: "logo_image" (또는 product_images, avatar)
    └── blob_id: [위의 blob 참조]

실제 파일 저장소
├── 로컬: storage/xxxxxxxx/filename
└── R2: pdrank-bucket/xxxxxxxx/filename
```

**장점:**
- ✅ `logo_image`, `product_images`, `avatar` 등으로 자동 구분
- ✅ 데이터베이스에서 전체 메타데이터 추적 가능
- ✅ 이미지 마이그레이션 쉬움 (로컬 ↔ R2)

---

## 🐛 트러블슈팅

### 문제 1: RAILS_ENV=production에서 에러 발생
```
Error retrieving instance profile credentials
missing required option :name
```

**원인**: R2 크리덴셜이 로드되지 않음

**해결책**:
```bash
# .env 파일 확인
cat .env | grep R2_

# 다시 로드하며 실행
dotenv -f .env RAILS_ENV=production rails console
```

### 문제 2: 로컬에서 이미지가 보이지 않음
**확인사항**:
1. `storage/` 디렉토리 존재 확인
2. 파일이 실제로 저장되었는지 확인: `ls -la storage/`
3. 데이터베이스 확인: `rails console`에서 `Product.first.logo_image.attached?`

### 문제 3: R2에 파일이 저장되지 않음
```bash
# R2 설정 확인
RAILS_ENV=production rails console
Rails.configuration.active_storage.service
Rails.configuration.active_storage.service_configurations
```

---

## 🔐 보안 체크리스트

- ✅ **`.env` 파일은 `.gitignore`에 포함** (크리덴셜 노출 방지)
- ✅ **개발 환경에서는 R2 크리덴셜 필요 없음** (로컬 사용)
- ✅ **배포 전에 프로덕션 환경에서 테스트** (실제 환경과 동일)

---

## 📝 개발 중 주의사항

| 상황 | 해야 할 것 | 하지 말아야 할 것 |
|------|----------|-----------------|
| 일반 개발 | `bin/dev` 또는 `rails s` 사용 | development 환경을 R2로 변경 ❌ |
| 배포 테스트 | `RAILS_ENV=production rails console` | production 환경을 locoal로 변경 ❌ |
| 이미지 확인 | 데이터베이스 쿼리 사용 | 파일 시스템 직접 접근 (권장 아님) |

---

## 🚀 배포 프로세스

1. **개발**: `bin/dev` (로컬 스토리지 사용)
2. **테스트**: `RAILS_ENV=production rails console` (R2 테스트)
3. **배포**: `git push` (자동으로 production 환경 실행)
4. **확인**: 배포된 서버에서 이미지 로드 확인

---

## 📚 관련 파일

| 파일 | 용도 |
|------|------|
| `config/storage.yml` | 스토리지 서비스 정의 |
| `config/environments/development.rb` | 개발 환경 설정 |
| `config/environments/production.rb` | 배포 환경 설정 |
| `.env` | R2 크리덴셜 (비밀) |
| `app/models/product.rb` | 이미지 첨부 정의 |
| `app/models/user.rb` | 사용자 아바타 첨부 정의 |

---

## ✅ 마지막 확인

마지막으로 현재 설정이 올바른지 확인하려면:

```bash
# 개발 환경 확인
grep "active_storage.service" config/environments/development.rb
# 출력: config.active_storage.service = :local

# 배포 환경 확인
grep "active_storage.service" config/environments/production.rb
# 출력: config.active_storage.service = :cloudflare
```

모두 올바르면 설정이 완료된 것입니다! ✨
