# ProductRank

**ProductRank**는 Product Hunt를 벤치마킹한 제품 발견 및 공유 플랫폼입니다. 새로운 제품과 서비스를 소개하고, 사용자들이 투표와 댓글을 통해 소통할 수 있는 커뮤니티 기반 플랫폼입니다.

## 🚀 주요 기능

- **제품 발견**: 매일 새로운 제품들을 발견하고 탐색
- **투표 시스템**: 마음에 드는 제품에 업보트 투표
- **댓글 시스템**: 제품에 대한 토론과 피드백
- **토픽 기반 분류**: AI, 생산성, 디자인 등 카테고리별 제품 분류
- **사용자 프로필**: 메이커와 사용자 프로필 관리
- **출시 일정**: 오늘, 이번 주, 이번 달별 제품 분류

## 🛠 기술 스택

- **Backend**: Ruby on Rails 8.0.2
- **Database**: SQLite (개발) / PostgreSQL (프로덕션)
- **Frontend**: Tailwind CSS 4.3, Stimulus JS
- **Assets**: Propshaft
- **Deployment**: Kamal (Docker)

## 📋 요구사항

- Ruby 3.3+
- Rails 8.0+
- Node.js (for asset compilation)
- SQLite3 (개발용)
- PostgreSQL (프로덕션용, 선택사항)

## 🏃 빠른 시작

### 1. 저장소 클론

```bash
git clone <repository-url>
cd productrank
```

### 2. 의존성 설치

```bash
# Ruby 의존성 설치
bundle install

# Node.js 의존성 설치 (Tailwind CSS)
npm install  # 또는 yarn install
```

### 3. 데이터베이스 설정

```bash
# 데이터베이스 생성 및 마이그레이션
bin/rails db:create
bin/rails db:migrate

# 샘플 데이터 생성 (60개 제품, 사용자, 토픽 등)
bin/rails db:seed
```

### 4. 서버 시작

```bash
# 개발 서버 시작 (Rails + Tailwind CSS 빌드)
bin/dev

# 또는 Rails 서버만 시작
bin/rails server
```

애플리케이션이 http://localhost:3000 에서 실행됩니다.

## 🗄 데이터베이스 구조

### 핵심 모델

- **User**: 사용자 및 메이커 정보
- **Product**: 제품 정보 (이름, 설명, 웹사이트, 로고 등)
- **Topic**: 제품 카테고리 (AI, 생산성, 디자인 등)
- **Launch**: 제품 출시 정보
- **Vote**: 사용자 투표 시스템
- **Comment**: 제품 댓글 및 토론
- **Collection**: 사용자 제품 컬렉션

### 관계도

```
User ↔ Product (through maker_roles)
Product ↔ Topic (through product_topics)
Product → Launch
Product ← Vote (from User)
Product ← Comment (from User)
User ← Collection ← Product
```

## 🎨 UI/UX 특징

- **Product Hunt 스타일 디자인**: 오리지널 Product Hunt UI를 벤치마킹한 레이아웃
- **반응형 디자인**: 데스크톱과 모바일에 최적화
- **컴팩트한 제품 카드**: 30-40% 축소된 크기로 더 많은 정보 표시
- **가로형 투표/댓글**: 세로형에서 가로형 레이아웃으로 개선
- **실제 제품 로고**: Clearbit API를 통한 실제 브랜드 로고 표시

## 🔧 개발 가이드

### 새로운 기능 추가

1. **모델 생성**: `bin/rails generate model ModelName`
2. **컨트롤러 생성**: `bin/rails generate controller ControllerName`
3. **마이그레이션**: `bin/rails db:migrate`
4. **테스트 실행**: `bin/rails test`

### CSS 커스터마이징

메인 스타일은 `app/assets/stylesheets/custom.css`에서 관리됩니다:

```css
/* 제품 카드 스타일 */
.product-card {
    background-color: #fff;
    border-radius: 8px;
    padding: 12px 16px;
    /* ... */
}

/* 가로형 투표/댓글 통계 */
.product-stats {
    display: flex;
    flex-direction: row;
    /* ... */
}
```

### 시드 데이터

`db/seeds.rb`에서 다음과 같은 데이터를 관리:
- **60개 제품**: 오늘(20개), 이번 주(20개), 이번 달(20개)
- **8개 토픽**: AI, 생산성, 디자인, 개발 등
- **4명의 사용자**: 메이커와 일반 사용자
- **투표 및 댓글**: 각 제품별 랜덤 투표와 댓글

## 🐘 PostgreSQL 설정

프로덕션 환경에서는 PostgreSQL 사용을 권장합니다.

자세한 설정 방법은 [PostgreSQL 설정 가이드](./POSTGRESQL_SETUP.md)를 참조하세요.

## 🚀 배포

### Docker 배포 (Kamal)

```bash
# Kamal 설정 확인
bin/kamal setup

# 배포
bin/kamal deploy
```

### 전통적인 배포

1. **환경 변수 설정**: 데이터베이스, 시크릿 키 등
2. **에셋 프리컴파일**: `bin/rails assets:precompile`
3. **마이그레이션**: `bin/rails db:migrate RAILS_ENV=production`
4. **서버 시작**: Puma, Passenger 등

## 🧪 테스트

```bash
# 전체 테스트 실행
bin/rails test

# 특정 테스트 실행
bin/rails test test/models/product_test.rb

# 시스템 테스트 (브라우저)
bin/rails test:system
```

## 📁 프로젝트 구조

```
app/
├── controllers/     # 컨트롤러 로직
├── models/         # 데이터 모델
├── views/          # ERB 템플릿
├── assets/         # CSS, JS, 이미지
└── helpers/        # 뷰 헬퍼

config/
├── database.yml    # 데이터베이스 설정
├── routes.rb      # 라우팅 설정
└── environments/  # 환경별 설정

db/
├── migrate/       # 데이터베이스 마이그레이션
├── seeds.rb      # 시드 데이터
└── schema.rb     # 데이터베이스 스키마

test/             # 테스트 파일
public/           # 정적 파일
```

## 🔜 로드맵

### Phase 1: 핵심 기능 (완료)
- ✅ 기본 UI/UX 구현
- ✅ 데이터베이스 모델 설계
- ✅ 제품 목록 및 표시
- ✅ 샘플 데이터 생성

### Phase 2: 사용자 기능 (진행중)
- 🔄 사용자 인증 시스템
- 🔄 제품 등록 기능
- 🔄 투표 시스템 구현
- 🔄 댓글 시스템 구현

### Phase 3: 고급 기능
- 📋 검색 기능
- 📋 알림 시스템
- 📋 이메일 뉴스레터
- 📋 API 개발

### Phase 4: 관리자 기능
- 📋 관리자 패널
- 📋 제품 승인 시스템
- 📋 사용자 관리
- 📋 통계 및 분석

## 🤝 기여 방법

1. 이슈 생성 또는 기존 이슈 확인
2. 새로운 브랜치 생성 (`git checkout -b feature/amazing-feature`)
3. 변경 사항 커밋 (`git commit -m '기능 추가: 놀라운 기능'`)
4. 브랜치에 푸시 (`git push origin feature/amazing-feature`)
5. Pull Request 생성

## 📝 라이선스

이 프로젝트는 MIT 라이선스 하에 제공됩니다.

## 🙋 문의 및 지원

- **이슈**: GitHub Issues를 통한 버그 리포트 및 기능 요청
- **토론**: GitHub Discussions를 통한 일반적인 질문

---

**ProductRank**로 새로운 제품을 발견하고 공유하세요! 🚀