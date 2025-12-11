# 🎯 R2 스토리지 최종 설정 요약

## ✅ 완료된 설정

### 1. 환경별 스토리지 설정
```
✅ development.rb  → config.active_storage.service = :local
✅ production.rb   → config.active_storage.service = :cloudflare
```

### 2. R2 환경변수 (.env)
```
✅ R2_ACCESS_KEY_ID       = 06861fe050e16e3b16d333073ddf0fb9
✅ R2_SECRET_ACCESS_KEY   = 5ec89ac979dde2498caafada254575122f80031711f9e688a2633e6c32ad4124
✅ R2_BUCKET              = pdrank
✅ R2_ENDPOINT            = https://2c44e0849f242e4f999d1cf9f69ed431.r2.cloudflarestorage.com
```

### 3. Active Storage 설정
```
✅ config/storage.yml에 cloudflare 서비스 정의됨
✅ Product 모델: logo_image, product_images 첨부
✅ User 모델: avatar 첨부
✅ 데이터베이스가 모든 이미지 메타데이터 관리
```

---

## 🚀 사용 방법

### 📌 일반 개발 (권장)
```bash
bin/dev
# 또는
rails s
```
- **스토리지**: 로컬 디스크 (`storage/` 디렉토리)
- **속도**: 빠름 ⚡
- **비용**: 0원 💰
- **크리덴셜**: 불필요 🔓

### 📌 R2 테스트 (배포 전)
```bash
RAILS_ENV=production bundle exec rails console
```

콘솔에서:
```ruby
# Product 이미지 확인
product = Product.first
puts product.logo_image.attached?  # true/false
puts product.logo_image.blob.key   # R2의 파일 경로

# User 아바타 확인
user = User.first
puts user.avatar.attached?         # true/false
```

---

## 🔄 이미지 흐름도

```
┌─────────────────────────────────────┐
│    사용자가 이미지 업로드            │
└──────────────┬──────────────────────┘
               │
        ┌──────▼──────┐
        │  Rails App   │
        └──────┬──────┘
               │
        ┌──────▼──────────────┐
        │ Active Storage      │
        └──────┬──────────────┘
               │
      ┌────────┴────────┐
      │                 │
   ┌──▼──┐        ┌────▼─────┐
   │LOCAL│        │CLOUDFLARE│
   │DISK │        │    R2    │
   └─────┘        └──────────┘
    (dev)          (production)

데이터베이스 (항상)
├── active_storage_blobs
│   └── 모든 이미지 메타데이터 저장
└── active_storage_attachments
    └── 이미지와 모델 연결 정보
```

---

## 🛠️ 트러블슈팅 가이드

### 문제: `Error retrieving instance profile credentials`
**원인**: 로컬 환경에서 AWS SDK가 EC2 메타데이터를 찾으려 시도
**해결**: 무시해도 됨 (배포 환경에서는 정상작동)

### 문제: `missing required option :name`
**원인**: R2_BUCKET 환경변수가 설정되지 않음
**해결**:
```bash
# .env 파일 확인
cat .env | grep R2_BUCKET

# 없으면 추가
echo 'R2_BUCKET=pdrank' >> .env
```

### 문제: 로컬에서 이미지가 보이지 않음
**확인사항**:
```bash
# 1. storage 디렉토리 존재 확인
ls -la storage/

# 2. 데이터베이스 확인
rails console
Product.first.logo_image.attached?  # true면 정상

# 3. 파일 존재 확인
find storage -name "*" -type f
```

---

## 📚 관련 파일 목록

| 파일 | 설명 |
|------|------|
| **STORAGE_GUIDE.md** | 📖 상세한 스토리지 가이드 문서 |
| **test_r2.sh** | 🧪 R2 연결 테스트 스크립트 |
| **config/storage.yml** | ⚙️ 스토리지 서비스 정의 |
| **config/environments/development.rb** | 🔧 개발 환경 설정 |
| **config/environments/production.rb** | 🔧 배포 환경 설정 |
| **.env** | 🔐 R2 크리덴셜 (`.gitignore`에 포함) |

---

## ✨ 최종 체크리스트

- [x] Development 환경: 로컬 스토리지 사용
- [x] Production 환경: Cloudflare R2 사용
- [x] R2 환경변수 설정됨
- [x] Active Storage 메타데이터 추적 중
- [x] 이미지 타입별 구분 (logo, product_images, avatar)
- [x] 로컬 개발 최적화
- [x] 배포 전 테스트 가능

---

## 🎓 학습 포인트

### Development vs Production
- **Development**: 빠른 반복 개발을 위해 로컬 디스크 사용
- **Production**: 안정성과 확장성을 위해 클라우드 스토리지(R2) 사용

### Active Storage의 장점
- 📊 데이터베이스에서 모든 이미지 추적
- 🔄 스토리지 변경이 쉬움 (로컬 ↔ R2)
- 🏷️ 이미지 타입별 자동 구분 (logo_image, product_images 등)
- 🔐 파일 접근 제어 가능

### 개발 워크플로우
```
1. 개발 시작    → bin/dev (로컬)
2. 이미지 테스트 → 로컬에서 자유롭게 테스트
3. 배포 전 테스트 → RAILS_ENV=production rails console
4. 배포         → git push (자동으로 production 환경 실행)
5. 확인         → 실제 서버에서 이미지 로드 확인
```

---

## 💡 팁

### 빠른 테스트
```bash
# R2 연결 상태 빠르게 확인
./test_r2.sh

# 개발 환경에서 이미지 정보 확인
rails console
Product.first.logo_image.blob.service_name  # "local"

# Production 환경에서 이미지 정보 확인
RAILS_ENV=production rails console
Product.first.logo_image.blob.service_name  # "cloudflare"
```

### 환경변수 다시 확인
```bash
# .env 파일이 올바르게 로드되는지 확인
RAILS_ENV=production rails runner "puts ENV['R2_BUCKET']"
# 출력: pdrank
```

---

## 🚨 주의사항

⚠️ **development.rb를 cloudflare로 변경하지 마세요!**
- 개발 속도 저하
- 불필요한 R2 비용 발생
- 네트워크 의존성 증가

⚠️ **production.rb를 local로 변경하지 마세요!**
- 배포 서버는 storage/ 디렉토리가 없음
- 이미지가 저장되지 않음
- 서버 재시작 시 모든 이미지 손실

---

**마지막 업데이트**: 2025-12-11
**상태**: ✅ 설정 완료 및 테스트 성공
