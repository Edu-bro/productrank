# 📁 R2 스토리지 폴더 구조 정리 가이드

## 현재 상황

### Active Storage의 기본 동작
```
폴더: storage/uu/5p/
파일: uu5pm5wp6f3wfh42yrpkhvt01gdt
원본: FlowSpace_logo.png

결과: storage/uu/5p/uu5pm5wp6f3wfh42yrpkhvt01gdt (해시로만 구분)
```

**문제점:**
- R2에 업로드될 때도 같은 구조
- 어떤 파일이 뭐인지 한눈에 구분 안 됨
- 유지보수 어려움

---

## ✅ 권장 방식

### 옵션 1: **현재 그대로 유지** (가장 간단)

**장점:**
- 👍 Rails Active Storage의 기본 방식
- 👍 보안 좋음 (직접 접근 불가)
- 👍 구현 간단
- 👍 확장성 우수

**단점:**
- 😞 R2 대시보드에서 파일 관리 어려움

**언제 사용:**
- ✅ 소규모 프로젝트
- ✅ 파일을 DB로만 관리
- ✅ R2 직접 접근 불필요

---

### 옵션 2: **체계적인 폴더 구조** (권장)

```
R2 Bucket 구조:
├── products/
│   ├── logos/
│   │   ├── 1/
│   │   │   └── uu5pm5wp6f3wfh42yrpkhvt01gdt.png
│   │   └── 2/
│   │       └── ct1wmz88z6mjtl3w1ag25m5l32cx.png
│   └── images/
│       ├── 1/
│       │   ├── twvfa0srkqtmy6h86lz8rgygatld.jpg
│       │   └── b1qpr86ud2x2owifyy3gfufkugtv.jpg
│       └── 2/
│           └── ...
└── users/
    ├── avatars/
    │   ├── 1/
    │   │   └── uu5pm5wp6f3wfh42yrpkhvt01gdt.png
    │   └── 2/
    │       └── ...
```

**장점:**
- 👍 R2 대시보드에서 직관적
- 👍 파일 관리 쉬움
- 👍 감시/감사(audit) 용이
- 👍 스토리지 정리 가능

**단점:**
- 😞 구현 복잡
- 😞 기존 파일 마이그레이션 필요

**언제 사용:**
- ✅ 대규모 프로젝트
- ✅ R2 직접 관리 필요
- ✅ 감시/분석 필요

---

## 🔨 구현 방법 (옵션 2)

### 1단계: Product 모델에 메서드 추가

```ruby
# app/models/product.rb
class Product < ApplicationRecord
  # ...

  def logo_image_key_prefix
    "products/logos/#{id}"
  end

  def product_images_key_prefix
    "products/images/#{id}"
  end

  # 새로 업로드할 때는 이미 정해진 경로로 감
end
```

### 2단계: 커스텀 Active Storage Service 사용

```ruby
# config/storage.yml
cloudflare:
  service: S3
  access_key_id: <%= ENV['R2_ACCESS_KEY_ID'] %>
  secret_access_key: <%= ENV['R2_SECRET_ACCESS_KEY'] %>
  region: auto
  bucket: <%= ENV['R2_BUCKET'] %>
  endpoint: <%= ENV['R2_ENDPOINT'] %>
  force_path_style: true
  public: true
  folder_prefix: true  # 이 옵션으로 폴더 구조 지원
```

### 3단계: 업로더 생성

```ruby
# app/uploaders/product_logo_uploader.rb
class ProductLogoUploader
  def initialize(product)
    @product = product
  end

  def upload(file)
    # Generate organized key
    key = "products/logos/#{@product.id}/#{SecureRandom.hex(16)}"

    # Upload to R2
    blob = ActiveStorage::Blob.create_and_upload!(
      io: file.open,
      filename: file.original_filename,
      content_type: file.content_type,
      key: key  # Override the key
    )

    @product.logo_image.attach(blob)
  end
end
```

---

## 🎯 현재 추천 사항

### 지금은 **옵션 1 유지**
- ✅ 이미 모든 파일이 저장됨
- ✅ 기능상 문제 없음
- ✅ 나중에 변경 가능

### 나중에 필요하면 **옵션 2로 마이그레이션**
- 새 파일부터 체계적인 구조 사용
- 기존 파일은 그대로 두어도 됨
- DB의 `active_storage_blobs.key` 값만 수정 가능

---

## 📊 파일 정리 쿼리 (나중에 사용)

```ruby
# 폴더 구조별로 정리된 파일 목록
RAILS_ENV=production rails runner "
  puts '=== 제품별 파일 현황 ==='
  Product.all.each do |product|
    puts \"\n제품: #{product.name} (ID: #{product.id})\"
    puts \"  로고: #{product.logo_image.attached? ? 'O' : 'X'}\"
    puts \"  이미지: #{product.product_images.count}개\"
  end
"
```

---

## 💡 최종 권장사항

| 상황 | 선택 |
|------|------|
| 현재 개발 중 | **옵션 1 유지** ✅ |
| 배포 후 파일 관리 필요 | **옵션 2로 전환** |
| R2 비용 최적화 필요 | **옵션 2로 정리** |
| 감시/분석 필요 | **옵션 2로 전환** |

---

## 🔗 관련 문서
- `STORAGE_GUIDE.md` - 스토리지 환경 설정
- `R2_SETUP_SUMMARY.md` - R2 설정 요약
- `QUICK_START_STORAGE.md` - 빠른 시작

