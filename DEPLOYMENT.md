# Render 배포 가이드

ProductRank를 Render에 배포하는 방법을 단계별로 안내합니다.

## 📋 사전 준비사항

이 프로젝트는 이미 Render 배포를 위한 설정이 완료되어 있습니다:
- ✅ PostgreSQL 지원 (`pg` gem 포함)
- ✅ `database.yml`이 `DATABASE_URL` 환경 변수 사용하도록 설정됨
- ✅ `render.yaml` 배포 설정 파일 생성됨
- ✅ `bin/render-build.sh` 빌드 스크립트 생성됨

## 🚀 Render 배포 단계

### 1. GitHub에 코드 푸시

먼저 모든 변경사항을 GitHub 저장소에 푸시합니다:

```bash
git add .
git commit -m "Add Render deployment configuration"
git push origin main
```

### 2. Render 계정 생성 및 로그인

1. [Render 웹사이트](https://render.com)에 접속
2. "Get Started" 또는 "Sign Up" 클릭
3. GitHub 계정으로 로그인

### 3. 새 Web Service 생성

1. Render 대시보드에서 "New +" 버튼 클릭
2. "Blueprint" 선택
3. GitHub 저장소 연결
   - "Connect a repository" 클릭
   - ProductRank 저장소 선택
4. Render가 `render.yaml` 파일을 자동으로 감지합니다
5. "Apply" 버튼 클릭

### 4. 환경 변수 설정

Render가 서비스를 생성한 후, 다음 환경 변수들을 설정해야 합니다:

#### 필수 환경 변수:

1. **RAILS_MASTER_KEY**
   - 값: `config/master.key` 파일의 내용을 복사
   - 경로: 프로젝트 루트 → `config/master.key`
   - 이 키는 암호화된 credentials를 읽는 데 필요합니다

2. **KAKAO_CLIENT_ID** (카카오 로그인 사용 시)
   - 카카오 개발자 콘솔에서 발급받은 REST API 키

3. **KAKAO_CLIENT_SECRET** (카카오 로그인 사용 시)
   - 카카오 개발자 콘솔에서 발급받은 Client Secret

환경 변수 설정 방법:
1. Render 대시보드에서 생성된 "productrank" 서비스 클릭
2. 왼쪽 메뉴에서 "Environment" 클릭
3. "Add Environment Variable" 클릭
4. 키와 값 입력
5. "Save Changes" 클릭

### 5. 배포 확인

1. Render가 자동으로 빌드 및 배포를 시작합니다
2. "Logs" 탭에서 배포 진행 상황 확인
3. 빌드가 완료되면 Render가 제공하는 URL로 접속 가능
   - 예: `https://productrank.onrender.com`

### 6. 데이터베이스 초기 설정 (선택사항)

#### 데이터베이스 시드 실행:

Render Shell에서 다음 명령어 실행:
1. Render 대시보드에서 "productrank" 서비스 클릭
2. 오른쪽 상단 "Shell" 클릭
3. 다음 명령어 실행:

```bash
bundle exec rake db:seed
```

## 🔧 문제 해결

### 배포 실패 시

1. **Logs 확인**: Render 대시보드의 "Logs" 탭에서 오류 메시지 확인
2. **환경 변수 확인**: RAILS_MASTER_KEY가 올바르게 설정되었는지 확인
3. **데이터베이스 연결**: DATABASE_URL이 자동으로 설정되었는지 확인

### SECRET_KEY_BASE 오류

`render-build.sh` 스크립트가 빌드 시 SECRET_KEY_BASE를 자동 생성하므로 별도 설정이 필요 없습니다.
만약 오류가 발생하면 `render.yaml`에서 `SECRET_KEY_BASE`가 `generateValue: true`로 설정되어 있는지 확인하세요.

### Asset Precompile 오류

`render-build.sh` 스크립트가 자동으로 처리하지만, 문제가 있다면:

```bash
RAILS_ENV=production bundle exec rake assets:precompile
```

### 데이터베이스 마이그레이션 오류

수동으로 마이그레이션 실행:

```bash
bundle exec rake db:migrate
```

## 📱 배포 후 설정

### 카카오 로그인 Redirect URI 설정

1. [카카오 개발자 콘솔](https://developers.kakao.com) 접속
2. 애플리케이션 선택
3. "플랫폼" → "Web" 설정
4. Redirect URI 추가:
   ```
   https://your-app-name.onrender.com/auth/kakao/callback
   ```

## 🔄 재배포

코드 변경 후 재배포:

```bash
git add .
git commit -m "Your commit message"
git push origin main
```

GitHub에 푸시하면 Render가 자동으로 재배포합니다.

## 💰 비용

- **Free Plan**: 데이터베이스와 웹 서비스 모두 무료
- **제한사항**:
  - 15분간 활동이 없으면 자동으로 sleep 모드
  - 첫 요청 시 cold start (30초~1분 소요)
  - 월 750시간 무료 (약 한 달)

## 📚 추가 리소스

- [Render 공식 Rails 가이드](https://render.com/docs/deploy-rails)
- [Render 환경 변수 설정](https://render.com/docs/environment-variables)
- [Render Blueprint 문서](https://render.com/docs/blueprint-spec)
