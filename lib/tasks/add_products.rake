namespace :products do
  desc "Add 50 new realistic products with images and logos"
  task add_50_products: :environment do
    puts "🚀 Adding 50 new products with full details..."

    # 최근 1개월 날짜 범위
    end_date = Date.yesterday
    start_date = 1.month.ago.to_date

    # 실제 제품 데이터 (50개)
    products_data = [
      # AI & 생산성 도구 (15개)
      {
        name: "VoiceScribe Pro",
        tagline: "AI 음성을 텍스트로 변환하는 전문가급 도구",
        description: "회의록, 인터뷰, 강의를 실시간으로 텍스트화하고 자동 요약 및 번역까지 지원하는 올인원 음성 변환 솔루션입니다.",
        website_url: "https://voicescribe.pro",
        logo_url: "https://logo.clearbit.com/otter.ai",
        cover_url: "https://images.unsplash.com/photo-1589903308904-1010c2294adc?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1589903308904-1010c2294adc?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1573164713714-d95e436ab8d6?w=600&h=400&fit=crop",
        pricing_info: "기본: 무료\n프로: $14.99/월\n비즈니스: $29.99/월",
        key_features: "실시간 음성 인식,자동 문장 부호,화자 구분,다국어 번역,AI 요약",
        topics: ["ai", "productivity"]
      },
      {
        name: "NotionFlow",
        tagline: "Notion을 더 강력하게 만드는 자동화 도구",
        description: "Notion 워크스페이스를 자동화하고 다른 앱들과 연동하여 생산성을 극대화하는 통합 플랫폼입니다.",
        website_url: "https://notionflow.app",
        logo_url: "https://logo.clearbit.com/notion.so",
        cover_url: "https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=600&h=400&fit=crop",
        pricing_info: "스타터: 무료\n프로: $9.99/월\n팀: $19.99/월",
        key_features: "Notion 자동화,앱 통합,템플릿 라이브러리,데이터 동기화,워크플로우 빌더",
        topics: ["productivity", "development"]
      },
      {
        name: "FocusGuard",
        tagline: "집중력을 지켜주는 AI 방해요소 차단기",
        description: "업무 중 방해되는 앱과 웹사이트를 스마트하게 차단하고 집중 시간을 추적하여 생산성을 극대화합니다.",
        website_url: "https://focusguard.app",
        logo_url: "https://logo.clearbit.com/freedom.to",
        cover_url: "https://images.unsplash.com/photo-1506784983877-45594efa4cbe?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1506784983877-45594efa4cbe?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=600&h=400&fit=crop",
        pricing_info: "개인: $6.99/월\n프로: $12.99/월",
        key_features: "스마트 차단,집중 모드,시간 추적,생산성 분석,사용 습관 리포트",
        topics: ["productivity", "ai"]
      },
      {
        name: "MeetingMind AI",
        tagline: "회의를 더 효율적으로 만드는 AI 어시스턴트",
        description: "회의 내용을 실시간으로 기록하고 요약하며 액션 아이템을 자동으로 추출하여 팀 생산성을 향상시킵니다.",
        website_url: "https://meetingmind.ai",
        logo_url: "https://logo.clearbit.com/fireflies.ai",
        cover_url: "https://images.unsplash.com/photo-1557804506-669a67965ba0?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1557804506-669a67965ba0?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=600&h=400&fit=crop",
        pricing_info: "무료: 기본 기능\n프로: $19.99/월\n엔터프라이즈: 문의",
        key_features: "자동 회의록,AI 요약,액션 아이템 추출,캘린더 통합,CRM 연동",
        topics: ["ai", "productivity"]
      },
      {
        name: "EmailGenius",
        tagline: "AI가 작성해주는 완벽한 이메일",
        description: "단 몇 단어만 입력하면 AI가 상황에 맞는 전문적인 이메일을 자동으로 작성해줍니다.",
        website_url: "https://emailgenius.ai",
        logo_url: "https://logo.clearbit.com/grammarly.com",
        cover_url: "https://images.unsplash.com/photo-1596526131083-e8c633c948d2?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1596526131083-e8c633c948d2?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&h=400&fit=crop",
        pricing_info: "프리: 무료\n프로: $9.99/월",
        key_features: "AI 이메일 작성,톤 조절,다국어 지원,템플릿,문법 검사",
        topics: ["ai", "productivity"]
      },
      {
        name: "QuickNote AI",
        tagline: "생각을 즉시 정리하는 AI 노트 앱",
        description: "음성, 텍스트, 이미지를 자유롭게 결합하여 노트를 작성하고 AI가 자동으로 정리하고 요약해줍니다.",
        website_url: "https://quicknote.ai",
        logo_url: "https://logo.clearbit.com/evernote.com",
        cover_url: "https://images.unsplash.com/photo-1455390582262-044cdead277a?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1455390582262-044cdead277a?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1531403009284-440f080d1e12?w=600&h=400&fit=crop",
        pricing_info: "기본: 무료\n플러스: $7.99/월",
        key_features: "AI 요약,음성 노트,OCR,클라우드 동기화,스마트 검색",
        topics: ["productivity", "ai"]
      },
      {
        name: "TaskMaster Pro",
        tagline: "AI가 도와주는 스마트 할일 관리",
        description: "우선순위를 자동으로 분석하고 최적의 작업 순서를 제안하는 지능형 할일 관리 도구입니다.",
        website_url: "https://taskmaster.pro",
        logo_url: "https://logo.clearbit.com/todoist.com",
        cover_url: "https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1507925921958-8a62f3d1a50d?w=600&h=400&fit=crop",
        pricing_info: "개인: 무료\n프로: $8.99/월\n팀: $14.99/월",
        key_features: "AI 우선순위,스마트 알림,반복 작업,팀 협업,캘린더 통합",
        topics: ["productivity", "ai"]
      },
      {
        name: "DocumentAI",
        tagline: "문서 작업을 자동화하는 AI 도구",
        description: "계약서, 보고서, 제안서 등 모든 문서를 AI가 자동으로 분석하고 요약하며 필요한 정보를 추출합니다.",
        website_url: "https://documentai.app",
        logo_url: "https://logo.clearbit.com/docusign.com",
        cover_url: "https://images.unsplash.com/photo-1568667256549-094345857637?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1568667256549-094345857637?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=600&h=400&fit=crop",
        pricing_info: "스타터: $12.99/월\n비즈니스: $24.99/월",
        key_features: "문서 분석,자동 요약,데이터 추출,OCR,전자 서명",
        topics: ["ai", "productivity"]
      },
      {
        name: "CalendarSync Pro",
        tagline: "모든 일정을 하나로 통합 관리",
        description: "Google, Outlook, Apple 캘린더를 하나로 통합하고 AI가 최적의 일정을 제안합니다.",
        website_url: "https://calendarsync.pro",
        logo_url: "https://logo.clearbit.com/calendly.com",
        cover_url: "https://images.unsplash.com/photo-1506784983877-45594efa4cbe?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1506784983877-45594efa4cbe?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=600&h=400&fit=crop",
        pricing_info: "개인: $4.99/월\n프로: $9.99/월",
        key_features: "캘린더 통합,AI 일정 제안,자동 시간 조절,회의 예약,리마인더",
        topics: ["productivity", "ai"]
      },
      {
        name: "PresentationPro AI",
        tagline: "AI가 만들어주는 전문가급 프레젠테이션",
        description: "주제만 입력하면 AI가 자동으로 슬라이드를 디자인하고 내용을 채워주는 혁신적인 도구입니다.",
        website_url: "https://presentationpro.ai",
        logo_url: "https://logo.clearbit.com/canva.com",
        cover_url: "https://images.unsplash.com/photo-1557804506-669a67965ba0?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1557804506-669a67965ba0?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1551836022-4c4c79ecde51?w=600&h=400&fit=crop",
        pricing_info: "무료: 기본 템플릿\n프로: $11.99/월",
        key_features: "AI 슬라이드 생성,스마트 디자인,템플릿,이미지 추천,애니메이션",
        topics: ["ai", "design"]
      },
      {
        name: "ReportBot",
        tagline: "자동으로 생성되는 데이터 리포트",
        description: "데이터를 연결하면 AI가 자동으로 인사이트를 분석하고 보기 쉬운 리포트를 생성합니다.",
        website_url: "https://reportbot.ai",
        logo_url: "https://logo.clearbit.com/tableau.com",
        cover_url: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=600&h=400&fit=crop",
        pricing_info: "스타터: $15.99/월\n비즈니스: $29.99/월",
        key_features: "자동 리포트 생성,데이터 시각화,인사이트 분석,대시보드,이메일 전송",
        topics: ["ai", "productivity"]
      },
      {
        name: "BrainstormAI",
        tagline: "AI와 함께하는 창의적 아이디어 회의",
        description: "브레인스토밍 세션에서 AI가 새로운 아이디어를 제안하고 기존 아이디어를 발전시켜줍니다.",
        website_url: "https://brainstorm.ai",
        logo_url: "https://logo.clearbit.com/miro.com",
        cover_url: "https://images.unsplash.com/photo-1552664730-d307ca884978?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1552664730-d307ca884978?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1531403009284-440f080d1e12?w=600&h=400&fit=crop",
        pricing_info: "개인: $7.99/월\n팀: $19.99/월",
        key_features: "AI 아이디어 생성,협업 보드,마인드맵,실시간 협업,템플릿",
        topics: ["ai", "productivity"]
      },
      {
        name: "AutoScheduler",
        tagline: "AI가 자동으로 짜주는 최적의 스케줄",
        description: "업무, 미팅, 개인 시간을 고려하여 AI가 하루 일정을 자동으로 최적화합니다.",
        website_url: "https://autoscheduler.app",
        logo_url: "https://logo.clearbit.com/reclaim.ai",
        cover_url: "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1506784983877-45594efa4cbe?w=600&h=400&fit=crop",
        pricing_info: "무료: 기본 기능\n프로: $9.99/월",
        key_features: "AI 스케줄링,자동 시간 배분,캘린더 통합,우선순위 관리,충돌 방지",
        topics: ["ai", "productivity"]
      },
      {
        name: "KnowledgeBase AI",
        tagline: "AI로 구축하는 스마트 지식 베이스",
        description: "팀의 모든 정보를 하나로 모으고 AI가 자동으로 분류하고 검색을 도와줍니다.",
        website_url: "https://knowledgebase.ai",
        logo_url: "https://logo.clearbit.com/confluence.atlassian.com",
        cover_url: "https://images.unsplash.com/photo-1544197150-b99a580bb7a8?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1544197150-b99a580bb7a8?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1573164713714-d95e436ab8d6?w=600&h=400&fit=crop",
        pricing_info: "팀: $12.99/월\n비즈니스: $24.99/월",
        key_features: "AI 자동 분류,스마트 검색,문서 연결,버전 관리,팀 협업",
        topics: ["ai", "productivity"]
      },
      {
        name: "WorkflowBuilder AI",
        tagline: "노코드로 만드는 AI 자동화 워크플로우",
        description: "코딩 없이 드래그앤드롭으로 업무 프로세스를 자동화하고 AI가 최적화합니다.",
        website_url: "https://workflowbuilder.ai",
        logo_url: "https://logo.clearbit.com/zapier.com",
        cover_url: "https://images.unsplash.com/photo-1557804506-669a67965ba0?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1557804506-669a67965ba0?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1504868584819-f8e8b4b6d7e3?w=600&h=400&fit=crop",
        pricing_info: "스타터: $14.99/월\n프로: $29.99/월",
        key_features: "노코드 빌더,앱 통합,AI 최적화,조건 분기,스케줄링",
        topics: ["ai", "productivity"]
      },

      # 디자인 도구 (10개)
      {
        name: "ColorMind Pro",
        tagline: "AI가 추천하는 완벽한 컬러 팔레트",
        description: "브랜드, 웹사이트, 앱 디자인을 위한 조화로운 색상 조합을 AI가 자동으로 생성합니다.",
        website_url: "https://colormind.pro",
        logo_url: "https://logo.clearbit.com/adobe.com",
        cover_url: "https://images.unsplash.com/photo-1541701494587-cb58502866ab?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1541701494587-cb58502866ab?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1525909002-1b05e0c869d8?w=600&h=400&fit=crop",
        pricing_info: "무료: 기본 팔레트\n프로: $6.99/월",
        key_features: "AI 색상 생성,팔레트 저장,컬러 코드 추출,접근성 체크,트렌드 색상",
        topics: ["design", "ai"]
      },
      {
        name: "LogoMaker AI",
        tagline: "5분만에 완성하는 전문가급 로고",
        description: "브랜드명과 업종만 입력하면 AI가 수백 가지 로고 디자인을 자동 생성합니다.",
        website_url: "https://logomaker.ai",
        logo_url: "https://logo.clearbit.com/looka.com",
        cover_url: "https://images.unsplash.com/photo-1626785774573-4b799315345d?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1626785774573-4b799315345d?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1561070791-2526d30994b5?w=600&h=400&fit=crop",
        pricing_info: "기본: $29 (일회성)\n프리미엄: $59",
        key_features: "AI 로고 생성,무제한 수정,벡터 파일,브랜드 키트,소셜미디어 템플릿",
        topics: ["design", "ai"]
      },
      {
        name: "MockupStudio",
        tagline: "제품 목업을 쉽게 만드는 디자인 도구",
        description: "수천 개의 목업 템플릿으로 제품, 앱, 웹사이트를 사실적으로 시연할 수 있습니다.",
        website_url: "https://mockupstudio.design",
        logo_url: "https://logo.clearbit.com/canva.com",
        cover_url: "https://images.unsplash.com/photo-1558655146-364adaf1fcc9?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1558655146-364adaf1fcc9?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1483478550801-ceba5fe50e8e?w=600&h=400&fit=crop",
        pricing_info: "무료: 10개/월\n프로: $12.99/월",
        key_features: "5000+ 템플릿,스마트 배치,고해상도 내보내기,배경 변경,다중 디바이스",
        topics: ["design", "productivity"]
      },
      {
        name: "FontPair AI",
        tagline: "완벽한 폰트 조합을 찾아주는 AI",
        description: "수천 개의 폰트 중에서 조화로운 폰트 페어를 AI가 자동으로 추천합니다.",
        website_url: "https://fontpair.ai",
        logo_url: "https://logo.clearbit.com/fonts.google.com",
        cover_url: "https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1457369804613-52c61a468e7d?w=600&h=400&fit=crop",
        pricing_info: "무료: 무제한 사용",
        key_features: "AI 폰트 페어링,실시간 프리뷰,웹폰트 코드,즐겨찾기,카테고리별 검색",
        topics: ["design", "ai"]
      },
      {
        name: "SketchFlow",
        tagline: "아이디어를 빠르게 스케치하는 디지털 도구",
        description: "손그림 같은 자연스러운 스케치로 UI/UX 아이디어를 빠르게 구체화할 수 있습니다.",
        website_url: "https://sketchflow.design",
        logo_url: "https://logo.clearbit.com/sketch.com",
        cover_url: "https://images.unsplash.com/photo-1581291518857-4e27b48ff24e?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1581291518857-4e27b48ff24e?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1561070791-2526d30994b5?w=600&h=400&fit=crop",
        pricing_info: "개인: $9.99/월\n팀: $19.99/월",
        key_features: "손그림 스타일,UI 컴포넌트,협업 기능,버전 관리,내보내기",
        topics: ["design", "productivity"]
      },
      {
        name: "AnimatePro",
        tagline: "코드 없이 만드는 웹 애니메이션",
        description: "드래그앤드롭으로 웹사이트와 앱에 넣을 수 있는 멋진 애니메이션을 제작합니다.",
        website_url: "https://animatepro.design",
        logo_url: "https://logo.clearbit.com/lottiefiles.com",
        cover_url: "https://images.unsplash.com/photo-1558655146-d09347e92766?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1558655146-d09347e92766?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1509395062183-67c5ad6faff9?w=600&h=400&fit=crop",
        pricing_info: "무료: 기본 애니메이션\n프로: $14.99/월",
        key_features: "노코드 에디터,Lottie 지원,JSON 내보내기,템플릿 라이브러리,프레임별 제어",
        topics: ["design", "development"]
      },
      {
        name: "DesignTokens",
        tagline: "디자인 시스템을 코드로 연결하는 도구",
        description: "디자인 토큰을 생성하고 관리하여 디자이너와 개발자 간 협업을 원활하게 합니다.",
        website_url: "https://designtokens.dev",
        logo_url: "https://logo.clearbit.com/figma.com",
        cover_url: "https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600&h=400&fit=crop",
        pricing_info: "오픈소스: 무료\n엔터프라이즈: $29.99/월",
        key_features: "토큰 관리,코드 변환,Figma 플러그인,버전 관리,문서 자동 생성",
        topics: ["design", "development"]
      },
      {
        name: "ImageOptim Pro",
        tagline: "이미지 최적화로 웹 성능 향상",
        description: "품질 손실 없이 이미지 파일 크기를 최대 80% 줄여 웹사이트 로딩 속도를 개선합니다.",
        website_url: "https://imageoptim.pro",
        logo_url: "https://logo.clearbit.com/tinypng.com",
        cover_url: "https://images.unsplash.com/photo-1618005198919-d3d4b5a92ead?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1618005198919-d3d4b5a92ead?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=600&h=400&fit=crop",
        pricing_info: "무료: 20장/일\n프로: $9.99/월",
        key_features: "무손실 압축,일괄 처리,WebP 변환,메타데이터 제거,API 제공",
        topics: ["design", "development"]
      },
      {
        name: "GridMaster",
        tagline: "반응형 그리드 시스템 생성 도구",
        description: "모든 스크린 사이즈에 맞는 반응형 그리드를 쉽게 디자인하고 코드로 내보낼 수 있습니다.",
        website_url: "https://gridmaster.design",
        logo_url: "https://logo.clearbit.com/bootstrap.com",
        cover_url: "https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=600&h=400&fit=crop",
        pricing_info: "무료: 기본 기능\n프로: $7.99/월",
        key_features: "그리드 생성기,CSS/Sass 코드,반응형 프리뷰,커스텀 브레이크포인트,템플릿",
        topics: ["design", "development"]
      },
      {
        name: "TypographyAI",
        tagline: "AI가 만드는 완벽한 타이포그래피",
        description: "웹사이트와 앱을 위한 최적의 폰트 사이즈, 행간, 자간을 AI가 자동으로 계산합니다.",
        website_url: "https://typography.ai",
        logo_url: "https://logo.clearbit.com/typekit.com",
        cover_url: "https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1457369804613-52c61a468e7d?w=600&h=400&fit=crop",
        pricing_info: "무료: 개인 프로젝트\n프로: $11.99/월",
        key_features: "AI 타입 스케일,가독성 분석,CSS 코드 생성,프리뷰,모범 사례",
        topics: ["design", "ai"]
      },

      # 개발 도구 (10개)
      {
        name: "CodeSnippetPro",
        tagline: "개발자를 위한 스마트 코드 스니펫 매니저",
        description: "자주 사용하는 코드를 저장하고 검색하며 팀과 공유할 수 있는 강력한 도구입니다.",
        website_url: "https://codesnippet.pro",
        logo_url: "https://logo.clearbit.com/github.com",
        cover_url: "https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=600&h=400&fit=crop",
        pricing_info: "개인: $4.99/월\n팀: $9.99/월",
        key_features: "코드 하이라이팅,태그 관리,팀 공유,VS Code 플러그인,클라우드 동기화",
        topics: ["development", "productivity"]
      },
      {
        name: "APITester Pro",
        tagline: "API 테스트를 쉽고 빠르게",
        description: "REST, GraphQL, WebSocket API를 테스트하고 문서화하며 모니터링하는 올인원 도구입니다.",
        website_url: "https://apitester.pro",
        logo_url: "https://logo.clearbit.com/postman.com",
        cover_url: "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1484417894907-623942c8ee29?w=600&h=400&fit=crop",
        pricing_info: "무료: 기본 기능\n프로: $14.99/월",
        key_features: "API 테스트,자동 문서화,환경 변수,팀 협업,CI/CD 통합",
        topics: ["development", "productivity"]
      },
      {
        name: "GitFlow Studio",
        tagline: "Git 워크플로우를 시각화하고 관리",
        description: "복잡한 Git 브랜치 전략을 시각적으로 관리하고 팀 협업을 개선합니다.",
        website_url: "https://gitflow.studio",
        logo_url: "https://logo.clearbit.com/github.com",
        cover_url: "https://images.unsplash.com/photo-1556075798-4825dfaaf498?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1556075798-4825dfaaf498?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1618401471353-b98afee0b2eb?w=600&h=400&fit=crop",
        pricing_info: "개인: 무료\n팀: $12.99/월",
        key_features: "브랜치 시각화,충돌 방지,자동 병합,코드 리뷰,릴리스 관리",
        topics: ["development", "productivity"]
      },
      {
        name: "DatabaseGUI Pro",
        tagline: "모든 데이터베이스를 하나의 UI로 관리",
        description: "MySQL, PostgreSQL, MongoDB 등 모든 데이터베이스를 직관적인 GUI로 관리합니다.",
        website_url: "https://databasegui.pro",
        logo_url: "https://logo.clearbit.com/mongodb.com",
        cover_url: "https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&h=400&fit=crop",
        pricing_info: "개인: $9.99/월\n팀: $19.99/월",
        key_features: "다중 DB 지원,쿼리 빌더,데이터 시각화,스키마 디자인,백업 자동화",
        topics: ["development", "productivity"]
      },
      {
        name: "DeployMaster",
        tagline: "원클릭 배포로 개발 속도 향상",
        description: "복잡한 배포 프로세스를 자동화하고 클라우드 인프라를 쉽게 관리합니다.",
        website_url: "https://deploymaster.dev",
        logo_url: "https://logo.clearbit.com/vercel.com",
        cover_url: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1504868584819-f8e8b4b6d7e3?w=600&h=400&fit=crop",
        pricing_info: "스타터: 무료\n프로: $19.99/월",
        key_features: "자동 배포,롤백,환경 관리,모니터링,알림",
        topics: ["development", "productivity"]
      },
      {
        name: "CodeReviewBot",
        tagline: "AI가 검토하는 스마트 코드 리뷰",
        description: "Pull Request를 자동으로 분석하고 버그, 보안 취약점, 스타일 문제를 찾아냅니다.",
        website_url: "https://codereviewbot.ai",
        logo_url: "https://logo.clearbit.com/github.com",
        cover_url: "https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=600&h=400&fit=crop",
        pricing_info: "오픈소스: 무료\n프라이빗: $24.99/월",
        key_features: "AI 코드 분석,자동 리뷰,보안 스캔,성능 제안,베스트 프랙티스",
        topics: ["development", "ai"]
      },
      {
        name: "PerformanceMonitor",
        tagline: "실시간 앱 성능 모니터링",
        description: "웹과 모바일 앱의 성능을 실시간으로 추적하고 병목 지점을 자동으로 발견합니다.",
        website_url: "https://perfmonitor.dev",
        logo_url: "https://logo.clearbit.com/newrelic.com",
        cover_url: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=600&h=400&fit=crop",
        pricing_info: "무료: 1개 프로젝트\n프로: $29.99/월",
        key_features: "실시간 모니터링,성능 분석,에러 추적,알림,대시보드",
        topics: ["development", "productivity"]
      },
      {
        name: "TestAutomation Pro",
        tagline: "AI 기반 자동화 테스트 도구",
        description: "수동 테스트를 자동화하고 AI가 테스트 케이스를 자동으로 생성합니다.",
        website_url: "https://testautomation.pro",
        logo_url: "https://logo.clearbit.com/selenium.dev",
        cover_url: "https://images.unsplash.com/photo-1516116216624-53e697fedbea?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1516116216624-53e697fedbea?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=600&h=400&fit=crop",
        pricing_info: "스타터: $15.99/월\n엔터프라이즈: $49.99/월",
        key_features: "AI 테스트 생성,E2E 테스트,시각적 테스트,CI/CD 통합,리포트",
        topics: ["development", "ai"]
      },
      {
        name: "DocGenerator AI",
        tagline: "코드에서 자동으로 문서 생성",
        description: "코드베이스를 분석하여 API 문서, 가이드, 튜토리얼을 자동으로 생성합니다.",
        website_url: "https://docgenerator.ai",
        logo_url: "https://logo.clearbit.com/readme.io",
        cover_url: "https://images.unsplash.com/photo-1568667256549-094345857637?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1568667256549-094345857637?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=600&h=400&fit=crop",
        pricing_info: "무료: 1개 프로젝트\n프로: $17.99/월",
        key_features: "자동 문서 생성,API 레퍼런스,코드 예제,검색 기능,버전 관리",
        topics: ["development", "ai"]
      },
      {
        name: "SecurityScanner Pro",
        tagline: "코드 보안 취약점 자동 검사",
        description: "코드베이스를 스캔하여 보안 취약점, 라이선스 문제, 종속성 이슈를 발견합니다.",
        website_url: "https://securityscanner.pro",
        logo_url: "https://logo.clearbit.com/snyk.io",
        cover_url: "https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&h=400&fit=crop",
        pricing_info: "오픈소스: 무료\n프로: $34.99/월",
        key_features: "취약점 스캔,라이선스 체크,종속성 분석,자동 수정,컴플라이언스",
        topics: ["development", "ai"]
      },

      # 헬스케어 & 웰빙 (8개)
      {
        name: "SleepBetter AI",
        tagline: "AI가 분석하는 수면 패턴과 개선 방법",
        description: "수면 데이터를 분석하여 개인화된 수면 개선 프로그램을 제공합니다.",
        website_url: "https://sleepbetter.ai",
        logo_url: "https://logo.clearbit.com/sleep.com",
        cover_url: "https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1511895426328-dc8714191300?w=600&h=400&fit=crop",
        pricing_info: "기본: 무료\n프리미엄: $7.99/월",
        key_features: "수면 추적,AI 분석,개선 제안,명상 가이드,스마트 알람",
        topics: ["health", "ai"]
      },
      {
        name: "NutritionCoach AI",
        tagline: "개인 맞춤형 AI 영양 코치",
        description: "식습관을 분석하고 건강 목표에 맞는 식단과 영양소 섭취를 추천합니다.",
        website_url: "https://nutritioncoach.ai",
        logo_url: "https://logo.clearbit.com/myfitnesspal.com",
        cover_url: "https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=600&h=400&fit=crop",
        pricing_info: "무료: 기본 추적\n프리미엄: $9.99/월",
        key_features: "식단 추적,영양소 분석,레시피 추천,쇼핑 리스트,진행 상황",
        topics: ["health", "ai"]
      },
      {
        name: "WorkoutPlanner AI",
        tagline: "AI가 만드는 나만의 운동 계획",
        description: "체력 수준과 목표에 맞춰 AI가 최적의 운동 루틴을 자동으로 생성합니다.",
        website_url: "https://workoutplanner.ai",
        logo_url: "https://logo.clearbit.com/nike.com",
        cover_url: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=600&h=400&fit=crop",
        pricing_info: "무료: 기본 플랜\n프리미엄: $11.99/월",
        key_features: "AI 운동 플랜,비디오 가이드,진행 추적,통계,커뮤니티",
        topics: ["health", "ai"]
      },
      {
        name: "MindfulBreath",
        tagline: "호흡으로 마음챙김을 실천하는 앱",
        description: "과학적으로 검증된 호흡법으로 스트레스를 줄이고 집중력을 향상시킵니다.",
        website_url: "https://mindfulbreath.app",
        logo_url: "https://logo.clearbit.com/headspace.com",
        cover_url: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1545205597-3d9d02c29597?w=600&h=400&fit=crop",
        pricing_info: "무료: 기본 세션\n프리미엄: $5.99/월",
        key_features: "가이드 호흡법,명상 타이머,스트레스 측정,통계,수면 명상",
        topics: ["health", "productivity"]
      },
      {
        name: "HabitTracker Pro",
        tagline: "좋은 습관을 만들고 나쁜 습관을 끊기",
        description: "과학적 접근법으로 습관을 형성하고 진행 상황을 시각적으로 추적합니다.",
        website_url: "https://habittracker.pro",
        logo_url: "https://logo.clearbit.com/habitica.com",
        cover_url: "https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=600&h=400&fit=crop",
        pricing_info: "무료: 5개 습관\n프리미엄: $6.99/월",
        key_features: "습관 추적,리마인더,통계,목표 설정,동기 부여",
        topics: ["health", "productivity"]
      },
      {
        name: "WaterReminder Plus",
        tagline: "건강한 수분 섭취를 위한 스마트 알림",
        description: "체중과 활동량을 고려하여 개인화된 수분 섭취 목표를 설정하고 알려줍니다.",
        website_url: "https://waterreminder.plus",
        logo_url: "https://logo.clearbit.com/waterminder.com",
        cover_url: "https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1523667864248-fc55f5bad7e2?w=600&h=400&fit=crop",
        pricing_info: "무료: 기본 추적\n프리미엄: $3.99/월",
        key_features: "섭취량 추적,스마트 알림,통계,목표 설정,Apple Health 연동",
        topics: ["health", "productivity"]
      },
      {
        name: "PostureGuard",
        tagline: "올바른 자세를 유지하도록 도와주는 앱",
        description: "카메라로 자세를 분석하고 바르지 않은 자세를 감지하면 알림을 보냅니다.",
        website_url: "https://postureguard.app",
        logo_url: "https://logo.clearbit.com/upright.com",
        cover_url: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?w=600&h=400&fit=crop",
        pricing_info: "무료: 기본 기능\n프리미엄: $8.99/월",
        key_features: "자세 분석,실시간 알림,운동 가이드,진행 추적,통계",
        topics: ["health", "ai"]
      },
      {
        name: "MentalHealth Companion",
        tagline: "AI 기반 정신 건강 관리 도우미",
        description: "일상 대화를 통해 감정 상태를 추적하고 전문적인 정신 건강 조언을 제공합니다.",
        website_url: "https://mentalhealthcompanion.ai",
        logo_url: "https://logo.clearbit.com/calm.com",
        cover_url: "https://images.unsplash.com/photo-1499209974431-9dddcece7f88?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1499209974431-9dddcece7f88?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=600&h=400&fit=crop",
        pricing_info: "무료: 기본 대화\n프리미엄: $12.99/월",
        key_features: "AI 상담,감정 추적,CBT 기법,명상,전문가 연결",
        topics: ["health", "ai"]
      },

      # 교육 & 학습 (7개)
      {
        name: "SmartFlashcards",
        tagline: "AI가 만드는 스마트 암기 카드",
        description: "학습 내용을 입력하면 AI가 자동으로 암기 카드를 생성하고 최적의 복습 시기를 알려줍니다.",
        website_url: "https://smartflashcards.app",
        logo_url: "https://logo.clearbit.com/anki.net",
        cover_url: "https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=600&h=400&fit=crop",
        pricing_info: "무료: 100장\n프리미엄: $6.99/월",
        key_features: "AI 카드 생성,간격 반복,통계,이미지 지원,팀 공유",
        topics: ["education", "ai"]
      },
      {
        name: "MathSolver AI",
        tagline: "사진만 찍으면 수학 문제를 풀어주는 AI",
        description: "수학 문제를 카메라로 찍으면 AI가 단계별 풀이와 함께 답을 알려줍니다.",
        website_url: "https://mathsolver.ai",
        logo_url: "https://logo.clearbit.com/photomath.com",
        cover_url: "https://images.unsplash.com/photo-1509228468518-180dd4864904?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1509228468518-180dd4864904?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=600&h=400&fit=crop",
        pricing_info: "무료: 기본 풀이\n플러스: $9.99/월",
        key_features: "수식 인식,단계별 풀이,개념 설명,그래프,역사",
        topics: ["education", "ai"]
      },
      {
        name: "EssayWriter AI",
        tagline: "AI가 도와주는 논문 작성 도구",
        description: "아웃라인 생성부터 교정까지 AI가 학술 논문 작성의 모든 과정을 지원합니다.",
        website_url: "https://essaywriter.ai",
        logo_url: "https://logo.clearbit.com/grammarly.com",
        cover_url: "https://images.unsplash.com/photo-1455390582262-044cdead277a?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1455390582262-044cdead277a?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?w=600&h=400&fit=crop",
        pricing_info: "기본: 무료\n프로: $14.99/월",
        key_features: "AI 아웃라인,문법 검사,표절 검사,인용 관리,스타일 가이드",
        topics: ["education", "ai"]
      },
      {
        name: "QuizMaster Pro",
        tagline: "자동으로 생성되는 퀴즈와 시험",
        description: "교재나 노트를 업로드하면 AI가 자동으로 퀴즈를 생성하여 학습을 돕습니다.",
        website_url: "https://quizmaster.pro",
        logo_url: "https://logo.clearbit.com/quizlet.com",
        cover_url: "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=600&h=400&fit=crop",
        pricing_info: "무료: 10문제/일\n프리미엄: $7.99/월",
        key_features: "AI 퀴즈 생성,다양한 문제 유형,성적 추적,경쟁 모드,공유",
        topics: ["education", "ai"]
      },
      {
        name: "StudyTimer Pro",
        tagline: "과학적 학습 타이머와 집중력 관리",
        description: "포모도로 기법과 간격 반복 학습을 결합하여 효율적인 공부를 도와줍니다.",
        website_url: "https://studytimer.pro",
        logo_url: "https://logo.clearbit.com/forest.app",
        cover_url: "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1501504905252-473c47e087f8?w=600&h=400&fit=crop",
        pricing_info: "무료: 기본 타이머\n프리미엄: $4.99/월",
        key_features: "포모도로 타이머,통계,과목별 추적,목표 설정,집중 음악",
        topics: ["education", "productivity"]
      },
      {
        name: "LanguageTutor AI",
        tagline: "24/7 AI 언어 학습 튜터",
        description: "원어민 수준의 AI와 실제 대화를 나누며 자연스럽게 외국어를 배웁니다.",
        website_url: "https://languagetutor.ai",
        logo_url: "https://logo.clearbit.com/duolingo.com",
        cover_url: "https://images.unsplash.com/photo-1546410531-bb4caa6b424d?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1546410531-bb4caa6b424d?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1543109740-4bdb38fda756?w=600&h=400&fit=crop",
        pricing_info: "무료: 기본 대화\n프리미엄: $12.99/월",
        key_features: "AI 대화,발음 교정,문법 설명,실시간 번역,진도 추적",
        topics: ["education", "ai"]
      },
      {
        name: "ReadingCompanion",
        tagline: "독서를 더 즐겁게 만드는 AI 도우미",
        description: "책을 읽으면서 이해하기 어려운 부분을 AI에게 질문하고 토론할 수 있습니다.",
        website_url: "https://readingcompanion.ai",
        logo_url: "https://logo.clearbit.com/goodreads.com",
        cover_url: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=400&fit=crop",
        gallery_urls: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&h=400&fit=crop,https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=600&h=400&fit=crop",
        pricing_info: "무료: 월 5권\n프리미엄: $8.99/월",
        key_features: "AI 질문 답변,요약,토론,독서 목록,진행 추적",
        topics: ["education", "ai"]
      }
    ]

    puts "\n📝 Creating products..."

    products_data.each_with_index do |data, index|
      # 랜덤 날짜 생성 (최근 1개월)
      random_days = rand(0..(end_date - start_date).to_i)
      random_date = start_date + random_days.days
      random_hour = rand(9..18)
      random_minute = rand(0..59)
      launch_datetime = random_date.to_time + random_hour.hours + random_minute.minutes

      begin
        product = Product.new(
          name: data[:name],
          tagline: data[:tagline],
          description: data[:description],
          website_url: data[:website_url],
          logo_url: data[:logo_url],
          cover_url: data[:cover_url],
          gallery_urls: data[:gallery_urls],
          pricing_info: data[:pricing_info],
          key_features: data[:key_features],
          status: :live,
          featured: false,
          launch_date: launch_datetime,
          user: User.where(role: :maker).sample
        )
        product.save(validate: false)

        # 토픽 추가
        data[:topics].each do |topic_slug|
          topic = Topic.find_by(slug: topic_slug)
          ProductTopic.create!(product: product, topic: topic) if topic
        end

        # 메이커 추가
        maker = User.where(role: :maker).sample
        MakerRole.create!(user: maker, product: product, role: "Creator")

        # 런치 생성
        Launch.create!(
          product: product,
          launch_date: launch_datetime,
          region: "KR",
          status: :live
        )

        # 투표 추가 (최근 제품일수록 많이)
        days_ago = (Date.current - random_date).to_i
        vote_count = case days_ago
                     when 0..7
                       rand(40..120)
                     when 8..20
                       rand(20..80)
                     else
                       rand(10..50)
                     end

        User.order("RANDOM()").limit(vote_count).each do |user|
          Vote.create!(user: user, product: product, weight: 1)
        rescue ActiveRecord::RecordNotUnique
          # Skip duplicates
        end

        # 댓글 추가
        comment_count = rand(5..15)
        User.order("RANDOM()").limit(comment_count).each do |commenter|
          Comment.create!(
            user: commenter,
            product: product,
            body: [
              "정말 유용한 도구네요! 강력 추천합니다.",
              "UI가 깔끔하고 사용하기 편해요.",
              "이런 기능을 기다리고 있었습니다!",
              "가격 대비 성능이 훌륭해요.",
              "개발팀의 노고가 느껴지는 제품입니다.",
              "베타 버전부터 사용했는데 정식 출시 축하드려요!",
              "경쟁 제품보다 확실히 나은 것 같아요.",
              "앞으로 어떤 기능이 더 추가될지 기대됩니다.",
              "팀에서 사용 중인데 생산성이 많이 올랐어요.",
              "고객 지원이 빠르고 친절합니다."
            ].sample,
            upvotes: rand(0..10)
          )
        rescue ActiveRecord::RecordNotUnique
          # Skip duplicates
        end

        puts "✅ #{index + 1}/50: #{product.name} (#{random_date})"
      rescue ActiveRecord::RecordInvalid => e
        puts "❌ Failed to create #{data[:name]}: #{e.message}"
      end
    end

    puts "\n🎉 Successfully added 50 new products!"
    puts "📊 Total products: #{Product.count}"
    puts "📅 Date range: #{start_date} ~ #{end_date}"
  end
end
