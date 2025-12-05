# ProductRank 개발 히스토리

## 프로젝트 개요
- **프로젝트명**: ProductRank
- **설명**: 새로운 제품을 발견하고 순위를 매기는 플랫폼 (Product Hunt 스타일)
- **기술 스택**: Rails 8.0.2.1, PostgreSQL, Turbo/Hotwire
- **시작일**: 2025-12-05

---

## 📅 개발 타임라인

### 2025-12-05 - 초기 설정 및 핵심 기능 구현

#### 1. 프로젝트 초기 설정
- Rails 8.0.2.1 프로젝트 생성
- PostgreSQL 데이터베이스 설정
- Git 저장소 초기화 및 GitHub 연동
  - 저장소: https://github.com/Edu-bro/productrank
  - 커밋 해시: `abb9cb6`

#### 2. 데이터베이스 모델 구축
**핵심 모델:**
- `User`: 사용자 관리 (OAuth 인증 지원)
- `Product`: 제품 정보
- `Vote`: 투표 시스템
- `Comment`: 댓글 및 대댓글 (parent-child 구조)
- `Topic`: 카테고리/태그
- `Launch`: 제품 출시 일정
- `MakerRole`: 제품 제작자 관계

**주요 관계:**
```ruby
Product
  - has_many :votes (counter_cache)
  - has_many :comments (counter_cache)
  - has_many :topics (through: product_topics)
  - has_many :maker_roles
  - has_one :launch
  - belongs_to :user

Comment
  - belongs_to :parent (optional, for replies)
  - has_many :replies (class_name: 'Comment')
```

#### 3. 인증 시스템
- **OAuth 통합**
  - Kakao 로그인
  - Google 로그인
- **세션 관리**
  - `SessionsController` 구현
  - Helper methods: `logged_in?`, `current_user`

#### 4. 제품 기능
**제품 목록 페이지** (`/products`)
- 카테고리별 필터링 (AI, Productivity, Design, Development, etc.)
- 정렬 옵션: Popular, Newest, Most Votes, Most Comments
- 페이지네이션 (Kaminari)
- 최적화된 쿼리 (counter cache, select specific fields)

**제품 상세 페이지** (`/products/:id`)
- 제품 정보 표시 (로고, 이름, 태그라인, 설명)
- 이미지 갤러리 (커버 이미지 + 추가 갤러리)
- 투표 버튼 (실시간 UI 업데이트)
- 댓글 시스템 (대댓글 지원)
- 팀원 정보 섹션
- 유사 제품 추천

#### 5. 투표 시스템
**특징:**
- 실시간 UI 업데이트 (낙관적 업데이트)
- 디바운싱 (300ms) - 연속 클릭 방지
- Counter cache 최적화
- 날아가는 삼각형 애니메이션

**구현 파일:**
- `app/views/layouts/application.html.erb` (전역 투표 함수)
- `app/views/products/show.html.erb` (상세 페이지 투표)
- `app/controllers/products_controller.rb` (vote, unvote actions)

#### 6. 댓글 & 대댓글 시스템
**구현 과정 및 해결한 문제:**

##### 문제 1: Turbo 인터셉션
- **증상**: 댓글 폼 제출 시 404 에러 발생
- **원인**: Rails 8에서 `local: true`만으로는 Turbo가 폼 제출을 가로채는 것을 막을 수 없음
- **해결**: `data: { turbo: false }` 추가
```erb
<%= form_with model: [@product, Comment.new],
              local: true,
              data: { turbo: false },
              class: "comment-form" do |form| %>
```

##### 문제 2: CommentsController 라우팅 에러
- **증상**: `The show action could not be found for the :find_comment callback`
- **원인**: `before_action :find_comment, only: [:show, :edit, :update, :destroy]`에서 `show` 액션이 정의되지 않음
- **해결**: `only` 옵션에서 `:show` 제거
```ruby
before_action :find_comment, only: [:edit, :update, :destroy]
```

**최종 구현:**
- 메인 댓글 작성
- 대댓글 (답글) 작성
- 댓글 수정/삭제 (권한 확인)
- Parent-child 관계로 답글 관리

#### 7. 런치 캘린더 & 리더보드
**런치 캘린더** (`/launches`)
- 오늘의 신규 제품
- 이번 주 출시 제품
- 이번 달 출시 제품
- 예정된 출시

**리더보드** (`/rankboard`)
- 일간 랭킹
- 주간 랭킹
- 월간 랭킹
- 연간 랭킹
- 전체 기간 랭킹

#### 8. 검색 기능
- 제품명 검색
- 설명 검색
- 태그라인 검색
- 자동완성 제안 (`/search/suggestions`)

#### 9. 관리자 대시보드
**경로**: `/admin`

**기능:**
- 제품 승인/거부
- 사용자 관리 (역할 변경)
- 출시 일정 관리
- 토픽 관리

#### 10. 디자인 시스템
**스타일:**
- 모던한 카드 기반 레이아웃
- 반응형 디자인 (모바일 최적화)
- 커스텀 CSS (Tailwind + Custom styles)
- Font Awesome & Remix Icons

**주요 CSS 파일:**
- `app/assets/stylesheets/application.css`
- `app/assets/stylesheets/custom.css`
- `app/assets/stylesheets/product_detail.css`
- `app/assets/stylesheets/modern_products.css`

#### 11. 제품 상세 페이지 개선 (최근 작업)
**변경사항:**
- 팀원 아바타 크기 수정 (80px → 32px)
- 댓글 내용 필드 수정 (`comment.body` → `comment.content`)
- Turbo 비활성화로 폼 제출 문제 해결
- 댓글 표시 오류 수정

---

## 🔧 기술적 최적화

### 성능 최적화
1. **Counter Cache**
   - `votes_count`, `comments_count`, `likes_count`
   - DB 쿼리 수 감소

2. **쿼리 최적화**
   - `includes`, `joins`를 사용한 N+1 문제 방지
   - `select`로 필요한 필드만 조회
   - 인덱스 추가

3. **캐싱**
   - Fragment caching for product lists
   - (현재 디버깅을 위해 일시적으로 비활성화)

### 보안
- CSRF 토큰 검증
- Strong parameters
- 권한 검사 (`can_edit_comment?`, `can_edit_product?`)
- OAuth 인증

---

## 📦 주요 Gem 및 라이브러리

### Backend
- `rails` (8.0.2.1)
- `pg` (PostgreSQL)
- `puma` (웹 서버)
- `omniauth-kakao`, `omniauth-google-oauth2` (OAuth)
- `kaminari` (페이지네이션)
- `image_processing` (이미지 처리)

### Frontend
- Turbo/Hotwire
- Import maps
- Font Awesome
- Remix Icons

---

## 🐛 해결한 주요 버그

### 1. 댓글 대댓글 기능 404 에러
- **일자**: 2025-12-05
- **증상**: POST `/products/:id/comments` 404 에러
- **근본 원인**: Turbo가 폼 제출을 가로챔 + CommentsController의 잘못된 before_action
- **해결**:
  - `data: { turbo: false }` 추가
  - `before_action` 수정

### 2. 댓글 내용 표시 오류
- **일자**: 2025-12-05
- **증상**: `undefined method 'body' for Comment`
- **근본 원인**: Comment 모델의 alias_attribute가 제대로 작동하지 않음
- **해결**: `comment.body` → `comment.content` 변경

### 3. 투표 상태 동기화 문제
- **일자**: 2025-12-05
- **증상**: 빠른 클릭 시 투표 수가 동기화되지 않음
- **해결**:
  - 디바운싱 (300ms)
  - 상태 관리 (`window.voteState`)
  - 서버 응답과 UI 동기화

---

## 📁 주요 파일 구조

```
app/
├── controllers/
│   ├── products_controller.rb      # 제품 CRUD, 투표
│   ├── comments_controller.rb      # 댓글 관리
│   ├── sessions_controller.rb      # 인증
│   ├── launches_controller.rb      # 런치 캘린더
│   ├── leaderboards_controller.rb  # 리더보드
│   └── admin/                      # 관리자 기능
├── models/
│   ├── product.rb                  # 제품 모델
│   ├── user.rb                     # 사용자 모델
│   ├── comment.rb                  # 댓글 모델 (parent-child)
│   ├── vote.rb                     # 투표 모델
│   └── topic.rb                    # 토픽 모델
├── views/
│   ├── products/
│   │   ├── index.html.erb         # 제품 목록
│   │   ├── show.html.erb          # 제품 상세 (댓글 포함)
│   │   └── new.html.erb           # 제품 등록
│   ├── layouts/
│   │   └── application.html.erb   # 전역 레이아웃 (투표 JS)
│   └── shared/
│       └── _product_card.html.erb # 제품 카드 partial
└── assets/
    └── stylesheets/
        ├── application.css
        ├── custom.css
        ├── product_detail.css
        └── modern_products.css
```

---

## 🎯 현재 상태

### ✅ 완료된 기능
- [x] 사용자 인증 (Kakao, Google OAuth)
- [x] 제품 CRUD
- [x] 투표 시스템 (실시간 UI 업데이트)
- [x] 댓글 & 대댓글 시스템
- [x] 카테고리별 필터링
- [x] 검색 기능
- [x] 런치 캘린더
- [x] 리더보드
- [x] 관리자 대시보드
- [x] 반응형 디자인
- [x] 이미지 갤러리
- [x] Git 저장소 설정 및 GitHub 푸시

### 🚧 알려진 제한사항
- 캐싱이 디버깅을 위해 일시적으로 비활성화됨
- 프로덕션 환경 미배포 (다음 단계)

---

## 🚀 다음 단계 (미완료)

### 배포
- [ ] Railway/Heroku/Fly.io 중 선택
- [ ] 환경 변수 설정
- [ ] 프로덕션 데이터베이스 설정
- [ ] 도메인 연결

### 기능 개선
- [ ] 좋아요 기능 완성
- [ ] 댓글 좋아요 기능
- [ ] 알림 시스템
- [ ] 사용자 프로필 페이지 개선
- [ ] 제품 북마크/컬렉션
- [ ] 이메일 알림
- [ ] SEO 최적화
- [ ] Open Graph 메타 태그 개선

### 성능 최적화
- [ ] 캐싱 재활성화
- [ ] CDN 설정
- [ ] 이미지 최적화 (WebP)
- [ ] Lazy loading

### 테스트
- [ ] RSpec 테스트 작성
- [ ] E2E 테스트
- [ ] 성능 테스트

---

## 📝 개발 노트

### 배운 교훈
1. **Rails 8의 Turbo**: `local: true`만으로는 충분하지 않음. `data: { turbo: false }` 필요
2. **Counter Cache**: 성능 최적화에 매우 효과적
3. **낙관적 업데이트**: 사용자 경험 개선에 중요
4. **Parent-Child 관계**: 대댓글 구현에 효과적

### 트러블슈팅 팁
- 서버 재시작이 필요한 경우: 뷰 파일 변경 시에도 발생 가능
- Turbo 관련 문제: 브라우저 콘솔에서 `turbo.es2017-esm.js` 에러 확인
- 여러 서버 인스턴스: `lsof -ti:3003 | xargs kill -9`로 정리

---

## 👥 기여자
- Edu-bro (GitHub: @Edu-bro)
- Claude Code (AI Pair Programmer)

---

## 📄 라이선스
(추후 추가)

---

**마지막 업데이트**: 2025-12-05
**버전**: 1.0.0 (Initial Release)
