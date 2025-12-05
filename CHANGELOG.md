# ProductRank 개발 변경 이력

## 2025-12-05 - UI 개선 및 투표/댓글 시각적 피드백 구현

### ✅ 완료된 작업

#### 1. 투표 및 댓글 기능 구현
- **파일**: `app/views/shared/_product_card.html.erb`
- **변경 내용**:
  - 투표 버튼을 실제 동작하는 링크로 변경 (`alert()` → `vote_product_path`)
  - 댓글 버튼 클릭 시 제품 상세 페이지의 댓글 섹션으로 이동 (`anchor: 'comments'`)
  - Rails 7+ Turbo 호환을 위해 `method: :post` → `data: { turbo_method: :post }` 변경

#### 2. 사용자 액션 시각적 피드백 추가
- **파일**: `app/models/product.rb`
- **추가된 메서드**:
  ```ruby
  def voted_by?(user)      # 사용자가 투표했는지 확인
  def commented_by?(user)  # 사용자가 댓글을 달았는지 확인
  ```

- **파일**: `app/views/shared/_product_card.html.erb`
- **UI 개선**:
  - **투표한 제품**: 삼각형 아이콘에 `#FF6154` 색상 채워짐 + 숫자도 같은 색상
  - **댓글 단 제품**: 말풍선 아이콘에 `#FF6154` 색상 채워짐 + 숫자도 같은 색상
  - **액션 없음**: 회색(`#6B7280`) 외곽선만 표시

#### 3. 댓글 섹션 앵커 추가
- **파일**: `app/views/products/show.html.erb`
- **변경 내용**: 댓글 섹션에 `id="comments"` 추가하여 직접 링크 가능하도록 개선

### 🎨 디자인 특징

- ProductHunt 스타일의 오렌지-레드 색상 (`#FF6154`) 사용
- 사용자가 상호작용한 제품을 한눈에 구분 가능
- 로그인하지 않은 사용자는 모든 아이콘이 회색으로 표시

### 📝 기술 세부사항

**라우팅** (`config/routes.rb:64-66`):
```ruby
resources :products do
  member do
    post :vote      # POST /products/:id/vote
    delete :unvote  # DELETE /products/:id/unvote
  end
end
```

**컨트롤러** (`app/controllers/products_controller.rb:256-276`):
- `vote` 액션: 사용자의 투표 생성
- `unvote` 액션: 사용자의 투표 삭제

**모델 관계**:
- `Vote` → `belongs_to :user, :product` (unique constraint on `user_id + product_id`)
- `Comment` → `belongs_to :user, :product`
- Counter cache: `votes_count`, `comments_count` 사용

### 🔧 이전 세션 작업 요약

#### UI 스타일 개선 (이전 세션)
- **파일**: `app/views/shared/_product_card.html.erb`
- 출시 시간 표시 제거 ("about 22 hours 전 출시")
- ProductHunt 스타일 버튼으로 변경:
  - 곡선형 삼각형 아이콘 (빈 삼각형, stroke만)
  - 버튼 박스/테두리 제거 (투명 배경)
  - 세로 방향 정렬 (아이콘 위, 숫자 아래)

#### 샘플 데이터 생성 (이전 세션)
- **파일**: `db/seeds_sample.rb`, `db/add_today_products.rb`, `db/attach_sample_logos.rb`
- 20개 샘플 제품 생성 (이번주 10개, 저번주 10개)
- 오늘 출시 제품 3개 추가
- Clearbit API로 실제 로고 이미지 다운로드 및 ActiveStorage 첨부

### ⚠️ 주의사항

1. **Rails 7+ Turbo 호환성**
   - `link_to`에서 POST/DELETE 요청 시 `data: { turbo_method: :post }` 사용
   - 구형 `method: :post`는 동작하지 않음 (404 에러 발생)

2. **Counter Cache 사용**
   - `votes_count`, `comments_count` 필드가 자동 업데이트됨
   - N+1 쿼리 방지를 위해 카운터 값 직접 사용

3. **current_user 의존성**
   - `voted_by?`, `commented_by?` 메서드는 `current_user` 필요
   - 로그인하지 않은 경우 `false` 반환

### 📋 다음 작업 고려사항

- [ ] 투표 취소(unvote) 기능 UI 추가
- [ ] 투표/댓글 액션 시 페이지 새로고침 없이 카운트 업데이트 (Turbo Streams)
- [ ] 좋아요(Like) 기능도 동일한 시각적 피드백 추가
- [ ] 모바일 반응형 테스트

---

## 이전 변경 이력

### 샘플 데이터 및 이미지 처리 (날짜 미상)
- 20개 샘플 제품 데이터베이스 추가
- Clearbit Logo API를 통한 실제 로고 이미지 첨부
- ActiveStorage 파일 첨부 구조 확립

### 시드 데이터 가이드 작성 (날짜 미상)
- **파일**: `db/SEEDING_GUIDE.md`
- launch_date 설정 시 올바른 패턴 문서화
- 흔한 실수 및 디버깅 가이드 추가
