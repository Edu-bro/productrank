# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Creating seed data..."

# Create Topics
topics = [
  { slug: "ai", name: "인공지능", description: "AI 및 머신러닝 관련 제품", color: "#ff6b6b" },
  { slug: "productivity", name: "생산성", description: "업무 효율성을 높이는 도구", color: "#4ecdc4" },
  { slug: "design", name: "디자인", description: "디자인 도구 및 리소스", color: "#45b7d1" },
  { slug: "development", name: "개발", description: "개발자를 위한 도구와 서비스", color: "#96ceb4" },
  { slug: "health", name: "건강", description: "건강 및 피트니스 앱", color: "#feca57" },
  { slug: "finance", name: "금융", description: "금융 및 투자 관련 서비스", color: "#ff9ff3" },
  { slug: "education", name: "교육", description: "학습 및 교육 플랫폼", color: "#54a0ff" },
  { slug: "ecommerce", name: "이커머스", description: "온라인 쇼핑 및 판매 도구", color: "#5f27cd" }
]

topics.each do |topic_data|
  topic = Topic.find_or_create_by!(slug: topic_data[:slug]) do |t|
    t.name = topic_data[:name]
    t.description = topic_data[:description]
    t.color = topic_data[:color]
  end
  puts "Created topic: #{topic.name}"
end

# Create Users
users_data = [
  { username: "john_doe", name: "John Doe", email: "john@example.com", role: :maker },
  { username: "jane_smith", name: "Jane Smith", email: "jane@example.com", role: :maker },
  { username: "mike_wilson", name: "Mike Wilson", email: "mike@example.com", role: :member },
  { username: "admin_user", name: "Admin User", email: "admin@example.com", role: :admin }
]

users_data.each do |user_data|
  user = User.find_or_create_by!(email: user_data[:email]) do |u|
    u.username = user_data[:username]
    u.name = user_data[:name]
    u.role = user_data[:role]
    u.reputation = rand(50..500)
  end
  puts "Created user: #{user.name}"
end

# Create Products - 60개 (오늘 20개, 이번주 20개, 이번달 20개)
products_data = [
  # 오늘 출시된 제품들 (20개)
  {
    name: "AI Assistant Pro", tagline: "혁신적인 AI 어시스턴트로 일상 업무를 자동화하세요",
    description: "일정 관리, 업무 처리, 생산성 향상을 도와주는 혁신적인 AI 어시스턴트입니다.", website_url: "https://aiassistantpro.com", status: :live, topics: ["ai", "productivity"], launch_date: 0.days.ago
  },
  {
    name: "FlowSpace", tagline: "원격 팀을 위한 협업 작업 공간",
    description: "원격 팀이 효율적으로 소통하고 프로젝트를 관리할 수 있도록 설계된 협업 플랫폼입니다.", website_url: "https://flowspace.io", status: :live, topics: ["productivity", "development"], launch_date: 0.days.ago
  },
  {
    name: "DesignKit Pro", tagline: "전문 디자이너를 위한 올인원 툴킷",
    description: "UI/UX 디자인, 프로토타이핑, 에셋 관리까지 한 번에 해결하는 디자인 도구입니다.", website_url: "https://designkitpro.com", status: :live, topics: ["design", "productivity"], launch_date: 0.days.ago
  },
  {
    name: "CodeSync", tagline: "개발자를 위한 실시간 코드 공유 플랫폼",
    description: "팀 개발 시 코드를 실시간으로 공유하고 협업할 수 있는 플랫폼입니다.", website_url: "https://codesync.dev", status: :live, topics: ["development", "productivity"], launch_date: 0.days.ago
  },
  {
    name: "HealthTracker+", tagline: "개인 맞춤형 건강 관리 어시스턴트",
    description: "AI 기반으로 개인의 건강 상태를 분석하고 맞춤형 운동 및 식단을 추천하는 헬스케어 앱입니다.", website_url: "https://healthtracker.plus", status: :live, topics: ["health", "ai"], launch_date: 0.days.ago
  },
  {
    name: "SmartBudget", tagline: "개인 재정 관리를 위한 스마트 예산 앱",
    description: "AI가 지출 패턴을 분석해 맞춤형 예산과 절약 팁을 제공합니다.", website_url: "https://smartbudget.app", status: :live, topics: ["finance", "ai"], launch_date: 0.days.ago
  },
  {
    name: "EduMaster", tagline: "온라인 학습을 혁신하는 교육 플랫폼",
    description: "개인화된 학습 경로와 실시간 피드백으로 효과적인 학습을 지원합니다.", website_url: "https://edumaster.co", status: :live, topics: ["education", "ai"], launch_date: 0.days.ago
  },
  {
    name: "ShopEasy", tagline: "간편하고 안전한 온라인 쇼핑몰 솔루션",
    description: "소상공인을 위한 원클릭 온라인 스토어 구축 및 관리 도구입니다.", website_url: "https://shopeasy.store", status: :live, topics: ["ecommerce", "productivity"], launch_date: 0.days.ago
  },
  {
    name: "MindSpace", tagline: "정신 건강을 위한 디지털 명상 공간",
    description: "개인 맞춤형 명상과 스트레스 관리 프로그램을 제공합니다.", website_url: "https://mindspace.app", status: :live, topics: ["health", "ai"], launch_date: 0.days.ago
  },
  {
    name: "DevTools Pro", tagline: "개발자 생산성을 극대화하는 통합 도구",
    description: "코딩, 디버깅, 배포까지 한 번에 해결하는 개발자 전용 툴킷입니다.", website_url: "https://devtools.pro", status: :live, topics: ["development", "productivity"], launch_date: 0.days.ago
  },
  {
    name: "CreativeStudio", tagline: "창작자를 위한 올인원 콘텐츠 제작 도구",
    description: "영상, 이미지, 오디오 편집을 한 곳에서 처리할 수 있는 창작 플랫폼입니다.", website_url: "https://creativestudio.io", status: :live, topics: ["design", "productivity"], launch_date: 0.days.ago
  },
  {
    name: "CryptoWallet+", tagline: "안전하고 직관적인 암호화폐 지갑",
    description: "다중 코인 지원과 고급 보안 기능을 갖춘 차세대 디지털 지갑입니다.", website_url: "https://cryptowallet.plus", status: :live, topics: ["finance", "development"], launch_date: 0.days.ago
  },
  {
    name: "FitnessPal AI", tagline: "AI 개인 트레이너와 함께하는 맞춤 운동",
    description: "개인의 체력 수준에 맞는 운동 계획과 실시간 피드백을 제공합니다.", website_url: "https://fitnesspal.ai", status: :live, topics: ["health", "ai"], launch_date: 0.days.ago
  },
  {
    name: "LearnCode", tagline: "코딩을 재미있게 배우는 인터랙티브 플랫폼",
    description: "게임화된 학습과 실습 프로젝트로 프로그래밍을 쉽게 익힐 수 있습니다.", website_url: "https://learncode.fun", status: :live, topics: ["education", "development"], launch_date: 0.days.ago
  },
  {
    name: "SocialBoost", tagline: "소셜미디어 마케팅 자동화 도구",
    description: "AI 기반 콘텐츠 생성과 최적 시간 포스팅으로 소셜미디어 성과를 극대화합니다.", website_url: "https://socialboost.app", status: :live, topics: ["productivity", "ai"], launch_date: 0.days.ago
  },
  {
    name: "CloudSync Pro", tagline: "멀티 클라우드 파일 동기화 솔루션",
    description: "Google Drive, Dropbox, OneDrive를 하나로 통합 관리합니다.", website_url: "https://cloudsync.pro", status: :live, topics: ["productivity", "development"], launch_date: 0.days.ago
  },
  {
    name: "VoiceNote AI", tagline: "음성을 텍스트로 변환하는 스마트 노트",
    description: "회의, 강의, 인터뷰를 실시간으로 텍스트화하고 자동 요약합니다.", website_url: "https://voicenote.ai", status: :live, topics: ["productivity", "ai"], launch_date: 0.days.ago
  },
  {
    name: "MenuMaster", tagline: "레스토랑을 위한 디지털 메뉴 솔루션",
    description: "QR코드 메뉴와 주문 시스템으로 식당 운영을 효율화합니다.", website_url: "https://menumaster.co", status: :live, topics: ["ecommerce", "productivity"], launch_date: 0.days.ago
  },
  {
    name: "PhotoMagic AI", tagline: "AI로 완성하는 완벽한 사진 편집",
    description: "원클릭으로 전문가급 사진 보정과 배경 제거를 제공합니다.", website_url: "https://photomagic.ai", status: :live, topics: ["design", "ai"], launch_date: 0.days.ago
  },
  {
    name: "TimeTracker Pro", tagline: "시간 관리의 새로운 기준",
    description: "프로젝트별 시간 추적과 생산성 분석으로 효율적인 업무를 지원합니다.", website_url: "https://timetracker.pro", status: :live, topics: ["productivity", "development"], launch_date: 0.days.ago
  },

  # 이번 주 출시된 제품들 (20개)
  {
    name: "DataViz Studio", tagline: "데이터를 아름다운 시각화로 변환",
    description: "복잡한 데이터를 직관적인 차트와 그래프로 쉽게 변환하는 도구입니다.", website_url: "https://dataviz.studio", status: :live, topics: ["design", "development"], launch_date: 2.days.ago
  },
  {
    name: "WriteBot", tagline: "AI 작가가 도와주는 글쓰기 도구",
    description: "블로그, 기사, 소설까지 다양한 글쓰기를 AI와 함께 완성하세요.", website_url: "https://writebot.ai", status: :live, topics: ["ai", "productivity"], launch_date: 3.days.ago
  },
  {
    name: "MeetingRoom", tagline: "화상회의의 새로운 경험",
    description: "고품질 화상통화와 실시간 협업 기능이 통합된 회의 플랫폼입니다.", website_url: "https://meetingroom.app", status: :live, topics: ["productivity", "development"], launch_date: 1.days.ago
  },
  {
    name: "InvestSmart", tagline: "똑똑한 투자를 위한 AI 어드바이저",
    description: "개인 투자 성향을 분석해 맞춤형 포트폴리오를 제안합니다.", website_url: "https://investsmart.ai", status: :live, topics: ["finance", "ai"], launch_date: 4.days.ago
  },
  {
    name: "LanguagePal", tagline: "AI와 함께하는 외국어 학습",
    description: "실제 대화를 통해 자연스럽게 외국어를 배울 수 있는 학습앱입니다.", website_url: "https://languagepal.app", status: :live, topics: ["education", "ai"], launch_date: 2.days.ago
  },
  {
    name: "ShopAnalytics", tagline: "이커머스 매출 최적화 도구",
    description: "온라인 쇼핑몰의 고객 행동을 분석해 매출 증대 전략을 제시합니다.", website_url: "https://shopanalytics.co", status: :live, topics: ["ecommerce", "ai"], launch_date: 5.days.ago
  },
  {
    name: "YogaFlow", tagline: "집에서 즐기는 프리미엄 요가 클래스",
    description: "전문 강사의 개인 맞춤 요가 프로그램과 실시간 자세 교정 기능을 제공합니다.", website_url: "https://yogaflow.app", status: :live, topics: ["health", "ai"], launch_date: 3.days.ago
  },
  {
    name: "CodeReview AI", tagline: "AI가 검토하는 코드 품질 관리",
    description: "자동 코드 리뷰와 버그 탐지로 개발 품질을 향상시킵니다.", website_url: "https://codereview.ai", status: :live, topics: ["development", "ai"], launch_date: 1.days.ago
  },
  {
    name: "BrandBuilder", tagline: "브랜드 아이덴티티 제작 플랫폼",
    description: "로고, 색상, 폰트까지 통일된 브랜드 디자인을 쉽게 만들어보세요.", website_url: "https://brandbuilder.design", status: :live, topics: ["design", "productivity"], launch_date: 6.days.ago
  },
  {
    name: "NutritionAI", tagline: "개인 맞춤 영양 관리 앱",
    description: "체질과 목표에 맞는 식단과 영양소 섭취량을 추천합니다.", website_url: "https://nutrition.ai", status: :live, topics: ["health", "ai"], launch_date: 4.days.ago
  },
  {
    name: "TaskFlow", tagline: "팀 프로젝트 관리의 완성형",
    description: "칸반보드, 간트차트, 시간추적이 통합된 프로젝트 관리 도구입니다.", website_url: "https://taskflow.team", status: :live, topics: ["productivity", "development"], launch_date: 2.days.ago
  },
  {
    name: "PodcastStudio", tagline: "팟캐스트 제작의 모든 것",
    description: "녹음, 편집, 배포까지 원스톱으로 처리하는 팟캐스트 제작 도구입니다.", website_url: "https://podcaststudio.co", status: :live, topics: ["design", "productivity"], launch_date: 5.days.ago
  },
  {
    name: "SecurityGuard", tagline: "개인정보 보호를 위한 올인원 솔루션",
    description: "비밀번호 관리, VPN, 악성코드 차단을 한 번에 제공합니다.", website_url: "https://securityguard.app", status: :live, topics: ["development", "productivity"], launch_date: 3.days.ago
  },
  {
    name: "StudyBuddy", tagline: "AI 튜터와 함께하는 개인화된 학습",
    description: "학습자의 진도와 이해도에 맞춰 최적화된 학습 계획을 제공합니다.", website_url: "https://studybuddy.edu", status: :live, topics: ["education", "ai"], launch_date: 1.days.ago
  },
  {
    name: "MarketPlace Pro", tagline: "중소기업을 위한 온라인 마켓플레이스",
    description: "쉽고 빠른 온라인 판매 시작과 통합 재고 관리를 제공합니다.", website_url: "https://marketplace.pro", status: :live, topics: ["ecommerce", "productivity"], launch_date: 6.days.ago
  },
  {
    name: "MeditationSpace", tagline: "마음의 평화를 찾는 명상 여정",
    description: "개인 스트레스 수준에 맞춘 명상과 호흡법을 가이드합니다.", website_url: "https://meditation.space", status: :live, topics: ["health", "ai"], launch_date: 4.days.ago
  },
  {
    name: "APIManager", tagline: "API 개발과 관리를 위한 통합 도구",
    description: "API 설계, 테스트, 문서화, 모니터링을 한 곳에서 처리합니다.", website_url: "https://apimanager.dev", status: :live, topics: ["development", "productivity"], launch_date: 2.days.ago
  },
  {
    name: "ColorPalette AI", tagline: "AI가 추천하는 완벽한 색상 조합",
    description: "브랜드와 프로젝트에 어울리는 색상 팔레트를 자동으로 생성합니다.", website_url: "https://colorpalette.ai", status: :live, topics: ["design", "ai"], launch_date: 5.days.ago
  },
  {
    name: "BudgetTracker", tagline: "가계부 작성의 새로운 방식",
    description: "카드 연동과 자동 분류로 간편한 가계부 관리를 제공합니다.", website_url: "https://budgettracker.app", status: :live, topics: ["finance", "productivity"], launch_date: 3.days.ago
  },
  {
    name: "SkillShare Pro", tagline: "전문가와 1:1로 배우는 실무 스킬",
    description: "현직 전문가의 멘토링과 실습 프로젝트로 실무 역량을 키웁니다.", website_url: "https://skillshare.pro", status: :live, topics: ["education", "productivity"], launch_date: 1.days.ago
  },

  # 이번 달 출시된 제품들 (20개)
  {
    name: "CloudStorage Max", tagline: "무제한 클라우드 저장소의 혁신",
    description: "안전하고 빠른 파일 동기화와 무제한 용량을 제공하는 클라우드 서비스입니다.", website_url: "https://cloudstorage.max", status: :live, topics: ["productivity", "development"], launch_date: 15.days.ago
  },
  {
    name: "AI Translator Pro", tagline: "실시간 다국어 번역의 완성",
    description: "100개 언어 지원과 문맥 이해 기반의 정확한 번역을 제공합니다.", website_url: "https://translator.pro", status: :live, topics: ["ai", "productivity"], launch_date: 12.days.ago
  },
  {
    name: "DesignSystem", tagline: "일관된 디자인을 위한 시스템",
    description: "브랜드 가이드라인과 컴포넌트 라이브러리를 통합 관리합니다.", website_url: "https://designsystem.co", status: :live, topics: ["design", "productivity"], launch_date: 20.days.ago
  },
  {
    name: "CryptoTrader AI", tagline: "AI 기반 암호화폐 자동 거래",
    description: "시장 분석과 자동 매매로 암호화폐 투자 수익을 극대화합니다.", website_url: "https://cryptotrader.ai", status: :live, topics: ["finance", "ai"], launch_date: 8.days.ago
  },
  {
    name: "OnlineClass", tagline: "인터랙티브 온라인 교육 플랫폼",
    description: "실시간 질의응답과 개인별 학습 진도 관리를 제공합니다.", website_url: "https://onlineclass.edu", status: :live, topics: ["education", "development"], launch_date: 25.days.ago
  },
  {
    name: "ShopBot", tagline: "온라인 쇼핑을 도와주는 AI 어시스턴트",
    description: "최저가 검색과 상품 추천으로 스마트한 쇼핑을 지원합니다.", website_url: "https://shopbot.ai", status: :live, topics: ["ecommerce", "ai"], launch_date: 18.days.ago
  },
  {
    name: "FitnessCoach AI", tagline: "개인 맞춤형 AI 피트니스 코치",
    description: "체력 수준과 목표에 맞는 운동 프로그램과 실시간 피드백을 제공합니다.", website_url: "https://fitnesscoach.ai", status: :live, topics: ["health", "ai"], launch_date: 10.days.ago
  },
  {
    name: "GitFlow Pro", tagline: "Git 워크플로우 관리의 혁신",
    description: "브랜치 전략과 코드 리뷰 프로세스를 자동화합니다.", website_url: "https://gitflow.pro", status: :live, topics: ["development", "productivity"], launch_date: 22.days.ago
  },
  {
    name: "IconLibrary", tagline: "무한한 아이콘 라이브러리",
    description: "10만개 이상의 벡터 아이콘과 커스터마이징 도구를 제공합니다.", website_url: "https://iconlibrary.design", status: :live, topics: ["design", "productivity"], launch_date: 14.days.ago
  },
  {
    name: "HealthMonitor", tagline: "웨어러블과 연동하는 건강 모니터링",
    description: "심박수, 수면, 활동량을 종합 분석해 건강 상태를 진단합니다.", website_url: "https://healthmonitor.app", status: :live, topics: ["health", "ai"], launch_date: 7.days.ago
  },
  {
    name: "TeamChat Pro", tagline: "팀 소통을 위한 차세대 메신저",
    description: "업무 효율성을 높이는 스마트 알림과 파일 공유 기능을 제공합니다.", website_url: "https://teamchat.pro", status: :live, topics: ["productivity", "development"], launch_date: 28.days.ago
  },
  {
    name: "VideoEditor AI", tagline: "AI가 편집하는 프로급 영상",
    description: "자동 컷 편집과 색보정으로 전문가급 영상을 쉽게 만들어보세요.", website_url: "https://videoeditor.ai", status: :live, topics: ["design", "ai"], launch_date: 16.days.ago
  },
  {
    name: "DatabaseManager", tagline: "데이터베이스 관리의 새로운 기준",
    description: "직관적인 GUI와 성능 최적화로 데이터베이스를 효율적으로 관리합니다.", website_url: "https://dbmanager.dev", status: :live, topics: ["development", "productivity"], launch_date: 11.days.ago
  },
  {
    name: "LearningPath", tagline: "개인화된 학습 로드맵 생성기",
    description: "목표와 현재 수준을 분석해 최적의 학습 경로를 제안합니다.", website_url: "https://learningpath.edu", status: :live, topics: ["education", "ai"], launch_date: 24.days.ago
  },
  {
    name: "StoreBuilder", tagline: "5분만에 완성하는 온라인 스토어",
    description: "드래그앤드롭으로 쉽게 만드는 전자상거래 사이트 빌더입니다.", website_url: "https://storebuilder.shop", status: :live, topics: ["ecommerce", "productivity"], launch_date: 19.days.ago
  },
  {
    name: "WellnessTracker", tagline: "전인적 웰빙 관리 솔루션",
    description: "신체, 정신, 감정 건강을 종합적으로 트래킹하고 개선 방안을 제시합니다.", website_url: "https://wellness.tracker", status: :live, topics: ["health", "ai"], launch_date: 13.days.ago
  },
  {
    name: "CodeSnippet", tagline: "개발자를 위한 코드 조각 라이브러리",
    description: "자주 사용하는 코드 패턴을 저장하고 팀과 공유할 수 있습니다.", website_url: "https://codesnippet.dev", status: :live, topics: ["development", "productivity"], launch_date: 26.days.ago
  },
  {
    name: "UIComponents", tagline: "재사용 가능한 UI 컴포넌트 키트",
    description: "React, Vue, Angular용 고품질 UI 컴포넌트를 제공합니다.", website_url: "https://uicomponents.design", status: :live, topics: ["design", "development"], launch_date: 9.days.ago
  },
  {
    name: "InvestmentBot", tagline: "AI 투자 자문사와 상담하기",
    description: "개인 투자 목표와 리스크를 분석해 맞춤형 투자 전략을 제안합니다.", website_url: "https://investmentbot.finance", status: :live, topics: ["finance", "ai"], launch_date: 21.days.ago
  },
  {
    name: "CourseCreator", tagline: "온라인 강의 제작 올인원 툴",
    description: "영상 녹화부터 수강생 관리까지 온라인 교육 사업의 모든 것을 지원합니다.", website_url: "https://coursecreator.edu", status: :live, topics: ["education", "productivity"], launch_date: 17.days.ago
  },

  # 오늘 출시 추가 8개
  {
    name: "NoteMaster AI", tagline: "AI가 정리하는 스마트 노트",
    description: "회의록, 강의 노트, 아이디어를 AI가 자동으로 정리하고 태그를 생성합니다.", website_url: "https://notemaster.ai", status: :live, topics: ["productivity", "ai"], launch_date: 0.days.ago
  },
  {
    name: "FocusTime", tagline: "집중력 향상을 위한 생산성 타이머",
    description: "포모도로 기법과 집중 음악, 방해 차단 기능으로 몰입을 도와줍니다.", website_url: "https://focustime.app", status: :live, topics: ["productivity", "health"], launch_date: 0.days.ago
  },
  {
    name: "QuickMock", tagline: "빠른 와이어프레임 및 목업 도구",
    description: "드래그 앤 드롭으로 5분 안에 프로토타입을 완성하는 디자인 도구입니다.", website_url: "https://quickmock.design", status: :live, topics: ["design", "productivity"], launch_date: 0.days.ago
  },
  {
    name: "SQLMaster", tagline: "SQL 쿼리 최적화 및 관리 도구",
    description: "복잡한 SQL 쿼리를 분석하고 성능 개선 방안을 제안합니다.", website_url: "https://sqlmaster.dev", status: :live, topics: ["development", "productivity"], launch_date: 0.days.ago
  },
  {
    name: "SleepWell", tagline: "과학 기반 수면 개선 앱",
    description: "수면 패턴 분석과 맞춤형 수면 루틴으로 깊은 잠을 도와줍니다.", website_url: "https://sleepwell.health", status: :live, topics: ["health", "ai"], launch_date: 0.days.ago
  },
  {
    name: "ExpenseTracker Pro", tagline: "사업자를 위한 경비 관리 솔루션",
    description: "영수증 스캔과 자동 분류로 경비 정산을 간소화합니다.", website_url: "https://expensetracker.pro", status: :live, topics: ["finance", "productivity"], launch_date: 0.days.ago
  },
  {
    name: "CodeMentor AI", tagline: "AI 코딩 멘토와 함께 성장하기",
    description: "실시간 코드 리뷰와 개선 제안으로 코딩 실력을 향상시킵니다.", website_url: "https://codementor.ai", status: :live, topics: ["education", "ai"], launch_date: 0.days.ago
  },
  {
    name: "SmartInventory", tagline: "재고 관리 자동화 시스템",
    description: "AI 수요 예측과 자동 발주로 재고 관리를 최적화합니다.", website_url: "https://smartinventory.shop", status: :live, topics: ["ecommerce", "ai"], launch_date: 0.days.ago
  },

  # 출시 예정 제품 5개
  {
    name: "VoiceClone AI", tagline: "나만의 AI 음성 클론 생성",
    description: "단 5분의 녹음으로 자연스러운 AI 음성을 만들 수 있습니다.", website_url: "https://voiceclone.ai", status: :scheduled, topics: ["ai", "productivity"], launch_date: 3.days.from_now
  },
  {
    name: "AR FitStudio", tagline: "증강현실 홈트레이닝 플랫폼",
    description: "AR 기술로 집에서 PT샵처럼 정확한 자세 교정을 받을 수 있습니다.", website_url: "https://arfitstudio.app", status: :scheduled, topics: ["health", "ai"], launch_date: 5.days.from_now
  },
  {
    name: "BlockchainDev Kit", tagline: "블록체인 개발을 쉽게 만드는 SDK",
    description: "스마트 컨트랙트 개발부터 배포까지 간소화하는 개발 도구입니다.", website_url: "https://blockchaindev.kit", status: :scheduled, topics: ["development", "finance"], launch_date: 7.days.from_now
  },
  {
    name: "AIEducator", tagline: "학생 수준에 맞춘 AI 개인교사",
    description: "학생의 이해도를 실시간 분석해 최적의 설명 방식을 제공합니다.", website_url: "https://aieducator.learn", status: :scheduled, topics: ["education", "ai"], launch_date: 10.days.from_now
  },
  {
    name: "SmartContract Builder", tagline: "노코드 스마트 컨트랙트 빌더",
    description: "코딩 없이 드래그앤드롭으로 스마트 컨트랙트를 생성합니다.", website_url: "https://smartcontract.build", status: :scheduled, topics: ["finance", "development"], launch_date: 14.days.from_now
  }
]

products_data.each_with_index do |product_data, index|
  # 각 제품에 랜덤 사용자 할당
  random_user = User.all.sample

  # validation을 건너뛰기 위해 with_options를 사용하거나 직접 create
  product = Product.find_by(name: product_data[:name])

  unless product
    product = Product.new(
      name: product_data[:name],
      tagline: product_data[:tagline],
      description: product_data[:description],
      website_url: product_data[:website_url],
      status: product_data[:status],
      featured: index < 3,
      user: random_user
    )

    # Validation 일시적으로 건너뛰기
    product.save(validate: false)
  end

  # Add special data for product #20 (TimeTracker Pro)
  if product.name == "TimeTracker Pro"
    product.update_columns(
      pricing_info: "무료 플랜: 기본 시간 추적\n프로 플랜: $9.99/월 - 고급 분석 및 팀 기능\n엔터프라이즈: $19.99/월 - 무제한 사용자 및 맞춤 기능"
    )
  end
  
  # Add topics
  product_data[:topics].each do |topic_slug|
    topic = Topic.find_by(slug: topic_slug)
    ProductTopic.find_or_create_by!(product: product, topic: topic) if topic
  end
  
  # Add maker
  user = User.where(role: :maker).sample
  MakerRole.find_or_create_by!(user: user, product: product, role: "Creator")

  # Add votes based on recency (더 최근 제품일수록 많은 투표)
  vote_count = case product_data[:launch_date]
                when 0.days.ago
                  rand(50..200)  # 오늘 제품: 50-200 투표
                when 1.days.ago..6.days.ago
                  rand(30..150)  # 이번주 제품: 30-150 투표
                else
                  rand(10..100)  # 이번달 제품: 10-100 투표
                end
  
  User.limit(vote_count).each do |user|
    Vote.find_or_create_by!(user: user, product: product) do |v|
      v.weight = 1
    end
  rescue ActiveRecord::RecordNotUnique
    # Skip if already exists
  end
  
  # Add some comments
  comment_count = rand(5..25)
  
  # Special comments for TimeTracker Pro (product #20)
  if product.name == "TimeTracker Pro"
    detailed_comments = [
      "정말 인상적인 시간 추적 도구입니다! 프리랜서로 일하면서 여러 프로젝트를 동시에 관리하는데, TimeTracker Pro 덕분에 시간 관리가 한층 체계적이 되었어요. 특히 자동 카테고리 분류 기능이 매우 유용합니다.",
      "6개월째 사용 중인데 정말 만족스러워요. 시간 블록 기능과 집중 모드가 생산성 향상에 큰 도움이 됩니다. Pomodoro 타이머와 통합되어 있는 점도 좋고요!",
      "팀에서 사용하기 시작했는데, 프로젝트별 시간 할당과 팀원별 작업 시간 추적이 정말 깔끔해요. 리포트 기능도 매우 상세해서 클라이언트에게 보고할 때 유용합니다.",
      "UI/UX가 매우 직관적이에요. 다른 시간 추적 앱들은 복잡하고 배우기 어려웠는데, 이건 처음 써도 금방 익숙해졌습니다. 디자인도 깔끔하고 보기 좋아요.",
      "자동 시간 추적 기능이 정말 혁신적입니다. 어떤 앱을 사용하는지, 어떤 웹사이트에 있는지 자동으로 감지해서 시간을 기록해주니까 일일이 수동으로 입력할 필요가 없어요.",
      "가격 대비 기능이 훌륭해요. 월 9.99달러면 정말 합리적인 가격이라고 생각합니다. 다른 프리미엄 도구들과 비교해도 경쟁력이 있어요.",
      "모바일 앱과 데스크톱 동기화가 완벽해요. 언제 어디서든 시간을 추적할 수 있고, 실시간으로 동기화되니까 정말 편리합니다.",
      "개발자분들이 정말 사용자 피드백을 잘 반영해주시는 것 같아요. 제가 요청했던 기능이 다음 업데이트에 추가되었더라고요. 이런 서비스는 처음이에요!",
      "통계와 분석 기능이 매우 상세해요. 어떤 작업에 시간을 가장 많이 쓰는지, 생산성이 높은 시간대가 언제인지 한눈에 볼 수 있어요.",
      "팀 협업 기능이 정말 좋습니다. 프로젝트 매니저로서 팀원들의 작업 진척도를 실시간으로 모니터링할 수 있어서 프로젝트 관리가 훨씬 수월해졌어요.",
      "백업과 데이터 보안도 신경 써주셔서 안심이 됩니다. 클라우드에 자동으로 백업되고, 데이터 암호화도 잘 되어 있어서 개인정보 걱정 없이 사용할 수 있어요.",
      "알림 기능이 스마트해요. 너무 자주 알림이 와서 방해가 되지도 않고, 필요할 때만 적절히 알려주니까 일에 집중하는데 도움이 됩니다."
    ]
    
    detailed_comments.each_with_index do |comment_text, idx|
      user = User.all.sample
      Comment.find_or_create_by!(user: user, product: product, body: comment_text) do |c|
        c.upvotes = rand(5..25)  # Higher upvotes for detailed comments
      end
    rescue ActiveRecord::RecordNotUnique
      # Skip if already exists
    end
  else
    # Regular comments for other products
    User.limit(comment_count).each do |commenter|
      Comment.find_or_create_by!(user: commenter, product: product) do |c|
        c.body = [
          "정말 유용한 도구네요! 강력 추천합니다.",
          "UI가 깔끔하고 사용하기 편해요.",
          "이런 기능을 기다리고 있었습니다!",
          "가격 대비 성능이 훌륭해요.",
          "개발팀의 노고가 느껴지는 제품입니다.",
          "베타 버전부터 사용했는데 정식 출시 축하드려요!",
          "경쟁 제품보다 확실히 나은 것 같아요.",
          "앞으로 어떤 기능이 더 추가될지 기대됩니다."
        ].sample
        c.upvotes = rand(0..15)
      end
    rescue ActiveRecord::RecordNotUnique
      # Skip if already exists
    end
  end
  
  # Add random likes to products
  like_count = case product_data[:launch_date]
                when 0.days.ago
                  rand(30..120)  # 오늘 제품: 30-120 좋아요
                when 1.days.ago..6.days.ago
                  rand(20..80)   # 이번주 제품: 20-80 좋아요
                else
                  rand(10..60)   # 이번달 제품: 10-60 좋아요
                end

  User.order("RANDOM()").limit(like_count).each do |liker|
    Like.find_or_create_by!(user: liker, product: product)
  rescue ActiveRecord::RecordNotUnique
    # Skip if already exists
  end

  puts "Created product: #{product.name} (launched #{product_data[:launch_date].to_i} days ago) - #{vote_count} votes, #{like_count} likes, #{product.comments.count} comments"
end

puts "\n=== Seed data created successfully! ==="
puts "Created #{User.count} users"
puts "Created #{Topic.count} topics"
puts "Created #{Product.count} products"
puts "Created #{Vote.count} votes"
puts "Created #{Like.count} likes"
puts "Created #{Comment.count} comments"
