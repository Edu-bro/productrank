# 모바일 최적화 가이드

## 현재 상태 분석

### ✅ 이미 구현된 부분
1. **Viewport 메타 태그**: `application.html.erb`에 설정됨
2. **기본 미디어 쿼리**: 일부 페이지에 768px, 480px 브레이크포인트 존재
3. **반응형 그리드**: 제품 목록 페이지에 모바일 1열, 태블릿 2열 구현

### ❌ 개선이 필요한 부분

#### 1. 헤더 네비게이션
- **문제**: 모바일에서 네비게이션 링크가 가로로 나열되어 공간 부족
- **해결**: 햄버거 메뉴 추가 필요

#### 2. 검색바
- **문제**: 모바일에서 검색바가 너무 넓거나 좁을 수 있음
- **해결**: 모바일에서 아이콘만 표시하고 클릭 시 확장

#### 3. 제품 카드
- **문제**: 일부 제품 카드가 모바일에서 너무 작거나 정보가 잘림
- **해결**: 터치 친화적인 크기와 간격 조정

#### 4. 폼 요소
- **문제**: 입력 필드와 버튼이 모바일에서 작을 수 있음
- **해결**: 최소 터치 영역 44x44px 보장

#### 5. 모달/팝업
- **문제**: 일부 모달이 모바일에서 화면을 벗어남
- **해결**: 전체 화면 모달로 변경

## 개선 방안

### 1. 공통 모바일 스타일 추가

`app/assets/stylesheets/custom.css`에 다음을 추가:

```css
/* ============================================
   모바일 최적화 공통 스타일
   ============================================ */

/* 터치 친화적인 최소 크기 */
@media (max-width: 768px) {
  /* 버튼 최소 크기 */
  button,
  .btn,
  a.btn {
    min-height: 44px;
    min-width: 44px;
    padding: 12px 16px;
    font-size: 16px; /* iOS 줌 방지 */
  }

  /* 입력 필드 최소 크기 */
  input[type="text"],
  input[type="email"],
  input[type="password"],
  input[type="search"],
  textarea,
  select {
    min-height: 44px;
    font-size: 16px; /* iOS 줌 방지 */
    padding: 12px;
  }

  /* 링크 최소 터치 영역 */
  a {
    min-height: 44px;
    display: inline-flex;
    align-items: center;
  }

  /* 카드 간격 증가 */
  .product-card,
  .card {
    margin-bottom: 16px;
  }

  /* 텍스트 가독성 */
  body {
    font-size: 16px;
    line-height: 1.6;
  }

  /* 스크롤 개선 */
  * {
    -webkit-overflow-scrolling: touch;
  }
}
```

### 2. 헤더 모바일 최적화

`app/assets/stylesheets/custom.css`에 추가:

```css
/* ============================================
   헤더 모바일 최적화
   ============================================ */

@media (max-width: 768px) {
  .header-container {
    flex-wrap: wrap;
    padding: 12px 16px;
  }

  .logo {
    font-size: 20px;
    flex: 0 0 auto;
  }

  /* 검색바 모바일 최적화 */
  .search-bar {
    order: 3;
    width: 100%;
    margin: 12px 0 0 0;
  }

  .search-bar .search-input {
    width: 100%;
    font-size: 16px; /* iOS 줌 방지 */
  }

  /* 네비게이션 모바일 메뉴 */
  .nav-links {
    order: 2;
    width: 100%;
    display: none; /* 기본적으로 숨김 */
    flex-direction: column;
    gap: 0;
    margin-top: 12px;
    border-top: 1px solid #e2e8f0;
    padding-top: 12px;
  }

  .nav-links.active {
    display: flex;
  }

  .nav-links a {
    padding: 12px 16px;
    border-radius: 8px;
    margin-bottom: 4px;
  }

  /* 햄버거 메뉴 버튼 */
  .mobile-menu-toggle {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 44px;
    height: 44px;
    background: none;
    border: none;
    cursor: pointer;
    order: 1;
    margin-left: auto;
    color: #1e293b;
    font-size: 24px;
  }

  .mobile-menu-toggle:focus {
    outline: 2px solid #3b82f6;
    outline-offset: 2px;
  }

  /* 데스크톱에서는 햄버거 메뉴 숨김 */
  @media (min-width: 769px) {
    .mobile-menu-toggle {
      display: none;
    }
    .nav-links {
      display: flex !important;
      flex-direction: row;
      width: auto;
      order: 0;
    }
  }

  /* 인증 버튼 모바일 최적화 */
  .auth-buttons {
    order: 1;
    display: flex;
    gap: 8px;
    align-items: center;
  }

  .login-btn,
  .signup-btn,
  .logout-btn {
    padding: 10px 16px;
    font-size: 14px;
    white-space: nowrap;
  }

  .user-profile-link {
    padding: 10px 12px;
    font-size: 14px;
  }
}
```

### 3. 제품 카드 모바일 최적화

```css
/* ============================================
   제품 카드 모바일 최적화
   ============================================ */

@media (max-width: 768px) {
  .product-card {
    padding: 16px;
    gap: 12px;
  }

  .product-image {
    width: 64px;
    height: 64px;
    flex-shrink: 0;
  }

  .product-title {
    font-size: 16px;
    line-height: 1.4;
    margin-bottom: 8px;
  }

  .product-description {
    font-size: 14px;
    line-height: 1.5;
    -webkit-line-clamp: 3; /* 모바일에서 더 많은 줄 표시 */
  }

  .product-stats {
    flex-wrap: wrap;
    gap: 12px;
    margin-top: 12px;
    padding-top: 12px;
    border-top: 1px solid #f1f5f9;
  }

  .stat-button {
    min-height: 44px;
    padding: 10px 14px;
    font-size: 14px;
  }
}
```

### 4. 모달 모바일 최적화

```css
/* ============================================
   모달 모바일 최적화
   ============================================ */

@media (max-width: 768px) {
  .product-modal,
  .share-modal {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    width: 100%;
    max-width: 100%;
    height: 100vh;
    max-height: 100vh;
    border-radius: 0;
    margin: 0;
  }

  .modal-content,
  .share-modal-content {
    width: 100%;
    height: 100%;
    max-height: 100vh;
    border-radius: 0;
    display: flex;
    flex-direction: column;
  }

  .modal-body,
  .share-modal-body {
    flex: 1;
    overflow-y: auto;
    -webkit-overflow-scrolling: touch;
  }

  /* 모바일에서 닫기 버튼 크기 증가 */
  .modal-close,
  .share-modal-close {
    width: 44px;
    height: 44px;
    font-size: 24px;
  }
}
```

### 5. 폼 모바일 최적화

```css
/* ============================================
   폼 모바일 최적화
   ============================================ */

@media (max-width: 768px) {
  .review-form,
  .reply-form {
    padding: 16px;
  }

  .form-actions {
    flex-direction: column;
    gap: 12px;
  }

  .form-actions .btn {
    width: 100%;
    min-height: 44px;
  }

  .rating-input-row {
    flex-wrap: wrap;
    gap: 12px;
  }

  .star-input {
    flex-wrap: wrap;
  }

  .star-input label {
    font-size: 24px; /* 모바일에서 더 큰 별 */
    min-width: 44px;
    min-height: 44px;
    display: flex;
    align-items: center;
    justify-content: center;
  }
}
```

### 6. 레이아웃 모바일 최적화

```css
/* ============================================
   레이아웃 모바일 최적화
   ============================================ */

@media (max-width: 768px) {
  .main-container {
    padding: 16px;
    gap: 20px;
  }

  .container {
    padding: 0 16px;
  }

  section {
    padding: 20px 16px;
  }

  /* 사이드바 모바일에서 상단으로 이동 */
  .sidebar {
    order: -1;
    position: static;
    margin-bottom: 24px;
  }

  .sidebar-sticky {
    position: static;
  }

  /* 그리드 레이아웃 모바일 최적화 */
  .content-layout {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  /* 이미지 갤러리 모바일 최적화 */
  .gallery-main img {
    height: 250px;
  }

  .gallery-thumbnails {
    gap: 8px;
    padding: 8px 0;
  }

  .thumbnail {
    width: 60px;
    height: 45px;
  }
}
```

## 구현 단계

### 1단계: 공통 모바일 스타일 추가
- `custom.css`에 공통 모바일 스타일 섹션 추가
- 터치 친화적인 최소 크기 설정

### 2단계: 헤더 모바일 메뉴 구현
- 햄버거 메뉴 버튼 추가
- JavaScript로 메뉴 토글 기능 구현
- `application.html.erb` 수정

### 3단계: 각 컴포넌트별 모바일 최적화
- 제품 카드
- 모달/팝업
- 폼 요소
- 레이아웃

### 4단계: 테스트
- 실제 모바일 기기에서 테스트
- 다양한 화면 크기 테스트 (320px, 375px, 414px, 768px)
- 터치 인터랙션 테스트

## 체크리스트

- [ ] Viewport 메타 태그 확인
- [ ] 모든 버튼이 최소 44x44px인지 확인
- [ ] 입력 필드가 최소 44px 높이인지 확인
- [ ] 폰트 크기가 16px 이상인지 확인 (iOS 줌 방지)
- [ ] 터치 영역이 충분한지 확인
- [ ] 모바일에서 스크롤이 부드러운지 확인
- [ ] 모달이 화면을 벗어나지 않는지 확인
- [ ] 이미지가 반응형인지 확인
- [ ] 텍스트가 잘리지 않는지 확인
- [ ] 네비게이션이 모바일에서 사용 가능한지 확인

## 참고사항

1. **iOS 줌 방지**: 입력 필드의 폰트 크기를 16px 이상으로 설정
2. **터치 영역**: 최소 44x44px 보장 (Apple HIG 권장사항)
3. **성능**: 모바일에서 불필요한 애니메이션 최소화
4. **접근성**: 키보드 네비게이션 지원 확인

