# 🚀 스토리지 설정 - 빠른 시작 가이드

## 일상적인 개발 (대부분의 경우)

```bash
# 그냥 이렇게 시작하면 됨
bin/dev
# 또는
rails s
```

✅ 로컬 스토리지 사용
✅ 빠른 속도
✅ R2 비용 없음

---

## R2 테스트 (배포 전, 문제 해결 시)

```bash
# 이렇게 실행
RAILS_ENV=production bundle exec rails console

# 그 다음 콘솔에서
product = Product.first
puts product.logo_image.attached?  # true or false
```

⚠️ 인터넷 필요
⚠️ R2 크리덴셜 필요
⚠️ API 호출로 시간이 걸릴 수 있음

---

## 자동 테스트

```bash
./test_r2.sh
```

---

## 문제 생기면?

1. **로컬에서 이미지 안 보임**
   ```bash
   ls -la storage/
   ```

2. **R2 연결 안 됨**
   ```bash
   cat .env | grep R2_
   ```

3. **더 자세한 정보**
   - 📖 `STORAGE_GUIDE.md` - 상세 가이드
   - 📋 `R2_SETUP_SUMMARY.md` - 요약본

---

## 핵심 규칙 3가지

| 규칙 | 이유 |
|------|------|
| ✅ 개발할 땐 `bin/dev` | 빠르고 간편 |
| ✅ 배포 전 R2 테스트 | 실제 환경과 동일 |
| ❌ dev를 R2로 바꾸지 말 것 | 느리고 비쌈 |

---

**더 알아보려면**: `STORAGE_GUIDE.md` 또는 `R2_SETUP_SUMMARY.md` 읽기
