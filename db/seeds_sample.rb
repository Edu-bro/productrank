# Sample Products Seed Script
# Creates 20 products with diverse categories for this week and last week

puts "🌱 Starting seed script..."

# Create a default user if none exists
user = User.first || User.create!(
  email: "demo@example.com",
  username: "demo_user",
  name: "Demo User",
  role: 0,
  reputation: 100
)

puts "✅ User created/found: #{user.username}"

# Get topics
topics = {
  ai: Topic.find_by(slug: 'ai'),
  productivity: Topic.find_by(slug: 'productivity'),
  design: Topic.find_by(slug: 'design'),
  development: Topic.find_by(slug: 'development'),
  health: Topic.find_by(slug: 'health'),
  finance: Topic.find_by(slug: 'finance'),
  education: Topic.find_by(slug: 'education'),
  ecommerce: Topic.find_by(slug: 'ecommerce')
}

puts "✅ Topics loaded"

# ⚠️ IMPORTANT: Use Date.current for accurate date calculations!
# ❌ DON'T: launch_offset: -2  (confusing, error-prone)
# ✅ DO: launch_date: Date.current - 2.days  (clear and correct)

today = Date.current  # Always use current date for seeding

# Sample products data
products_data = [
  # This Week Products (10 products)
  {
    name: "CodeGenius AI",
    tagline: "AI 기반 실시간 코드 완성 및 리뷰 도구",
    description: "개발자를 위한 지능형 코드 어시스턴트로, 실시간 코드 완성, 버그 탐지, 리팩토링 제안을 제공합니다. GPT-4를 기반으로 한 최첨단 AI 기술을 활용합니다.",
    website_url: "https://example.com/ai-code-assistant",
    logo_url: "https://via.placeholder.com/100/4A90E2/ffffff?text=AI",
    cover_url: "https://via.placeholder.com/800x400/4A90E2/ffffff?text=AI+Code+Assistant",
    pricing_info: "월 $29부터 시작",
    status: :live,
    featured: true,
    topics: [:ai, :development],
    launch_date: today - 2.days,  # ✅ 2 days ago (clear!)
    votes: 45,
    likes: 28,
    comments: 12,
    company_name: "CodeAI Inc.",
    founded_year: 2023,
    headquarters: "San Francisco, CA",
    employee_count: "11-50"
  },
  {
    name: "BrainBoost Focus",
    tagline: "뇌과학 기반 집중력 향상 앱",
    description: "과학적으로 입증된 방법으로 집중력을 높이고 생산성을 극대화하는 앱입니다. 포모도로 기법, 백색소음, 작업 추적 기능을 통합했습니다.",
    website_url: "https://example.com/focusflow",
    logo_url: "https://via.placeholder.com/100/50E3C2/ffffff?text=FF",
    cover_url: "https://via.placeholder.com/800x400/50E3C2/ffffff?text=FocusFlow",
    pricing_info: "무료, 프리미엄 $9.99/월",
    status: :live,
    featured: true,
    topics: [:productivity, :health],
    launch_offset: -1, # yesterday
    votes: 67,
    likes: 42,
    comments: 18,
    company_name: "MindTech Labs",
    founded_year: 2022,
    headquarters: "Seoul, Korea"
  },
  {
    name: "SystemKit Designer",
    tagline: "팀을 위한 올인원 디자인 시스템 관리 도구",
    description: "디자인 시스템을 쉽게 만들고 관리할 수 있는 협업 플랫폼입니다. Figma, Sketch와 완벽하게 통합되며, 코드 자동 생성 기능을 제공합니다.",
    website_url: "https://example.com/designsystem",
    logo_url: "https://via.placeholder.com/100/F5A623/ffffff?text=DS",
    cover_url: "https://via.placeholder.com/800x400/F5A623/ffffff?text=DesignSystem",
    pricing_info: "팀당 $49/월",
    status: :live,
    featured: false,
    topics: [:design, :productivity],
    launch_offset: -3, # 3 days ago
    votes: 38,
    likes: 25,
    comments: 8,
    company_name: "DesignHub Co.",
    founded_year: 2021,
    headquarters: "New York, NY",
    employee_count: "51-100"
  },
  {
    name: "VitalCare AI",
    tagline: "개인 맞춤형 AI 건강 관리 플랫폼",
    description: "AI가 분석한 건강 데이터를 바탕으로 맞춤형 운동, 식단, 수면 관리를 제공합니다. 웨어러블 기기와 연동하여 실시간 건강 모니터링이 가능합니다.",
    website_url: "https://example.com/healthtrack",
    logo_url: "https://via.placeholder.com/100/7ED321/ffffff?text=HT",
    cover_url: "https://via.placeholder.com/800x400/7ED321/ffffff?text=HealthTrack",
    pricing_info: "무료, 프리미엄 $14.99/월",
    status: :live,
    featured: true,
    topics: [:health, :ai],
    launch_offset: -1, # yesterday
    votes: 52,
    likes: 35,
    comments: 14,
    company_name: "HealthAI Corp.",
    founded_year: 2023,
    headquarters: "Boston, MA"
  },
  {
    name: "MoneyMind Pro",
    tagline: "똑똑한 개인 재무 관리 어시스턴트",
    description: "자동 지출 분류, 예산 추적, 저축 목표 설정을 통해 재정 건강을 관리합니다. AI가 지출 패턴을 분석하고 맞춤형 절약 팁을 제공합니다.",
    website_url: "https://example.com/budgetwise",
    logo_url: "https://via.placeholder.com/100/BD10E0/ffffff?text=BW",
    cover_url: "https://via.placeholder.com/800x400/BD10E0/ffffff?text=BudgetWise",
    pricing_info: "무료",
    status: :live,
    featured: false,
    topics: [:finance, :productivity],
    launch_offset: -4, # 4 days ago
    votes: 29,
    likes: 18,
    comments: 6,
    company_name: "FinTech Solutions",
    founded_year: 2022,
    headquarters: "London, UK",
    employee_count: "11-50"
  },
  {
    name: "SkillForge Academy",
    tagline: "전문가가 만든 인터랙티브 학습 플랫폼",
    description: "코딩, 디자인, 마케팅 등 다양한 분야의 실습 중심 강의를 제공합니다. 프로젝트 기반 학습으로 실전 경험을 쌓을 수 있습니다.",
    website_url: "https://example.com/learnhub",
    logo_url: "https://via.placeholder.com/100/4A148C/ffffff?text=LH",
    cover_url: "https://via.placeholder.com/800x400/4A148C/ffffff?text=LearnHub",
    pricing_info: "월 $29, 연간 $199",
    status: :live,
    featured: false,
    topics: [:education, :development],
    launch_offset: -2, # 2 days ago
    votes: 34,
    likes: 22,
    comments: 9,
    company_name: "EduTech Platform",
    founded_year: 2021,
    headquarters: "Singapore"
  },
  {
    name: "CommerceBoost AI",
    tagline: "AI 기반 이커머스 자동화 솔루션",
    description: "상품 설명 자동 생성, 가격 최적화, 재고 관리를 AI로 자동화합니다. Shopify 스토어의 매출을 평균 40% 증가시킵니다.",
    website_url: "https://example.com/shopifyai",
    logo_url: "https://via.placeholder.com/100/E91E63/ffffff?text=SA",
    cover_url: "https://via.placeholder.com/800x400/E91E63/ffffff?text=ShopifyAI",
    pricing_info: "$99/월",
    status: :live,
    featured: true,
    topics: [:ecommerce, :ai],
    launch_offset: -1, # yesterday
    votes: 56,
    likes: 38,
    comments: 16,
    company_name: "Commerce AI Ltd.",
    founded_year: 2023,
    headquarters: "Toronto, Canada",
    employee_count: "11-50"
  },
  {
    name: "DocuMatic Pro",
    tagline: "자동으로 생성되는 API 문서화 도구",
    description: "코드에서 자동으로 API 문서를 생성하고 항상 최신 상태로 유지합니다. 인터랙티브 테스트 환경과 다국어 지원을 포함합니다.",
    website_url: "https://example.com/devdocs",
    logo_url: "https://via.placeholder.com/100/009688/ffffff?text=DD",
    cover_url: "https://via.placeholder.com/800x400/009688/ffffff?text=DevDocs",
    pricing_info: "무료, 팀 $39/월",
    status: :live,
    featured: false,
    topics: [:development, :productivity],
    launch_offset: -3, # 3 days ago
    votes: 41,
    likes: 27,
    comments: 11,
    company_name: "DocGen Inc.",
    founded_year: 2022,
    headquarters: "Berlin, Germany"
  },
  {
    name: "HueHarmony AI",
    tagline: "AI가 추천하는 완벽한 컬러 조합",
    description: "이미지 업로드나 키워드 입력만으로 아름다운 색상 팔레트를 생성합니다. 접근성 검사와 다양한 내보내기 형식을 지원합니다.",
    website_url: "https://example.com/colorpalette",
    logo_url: "https://via.placeholder.com/100/FF5722/ffffff?text=CP",
    cover_url: "https://via.placeholder.com/800x400/FF5722/ffffff?text=ColorPalette",
    pricing_info: "무료, 프로 $9/월",
    status: :live,
    featured: false,
    topics: [:design, :ai],
    launch_offset: -5, # 5 days ago
    votes: 48,
    likes: 31,
    comments: 13,
    company_name: "Creative Tools Co.",
    founded_year: 2023,
    headquarters: "Amsterdam, Netherlands"
  },
  {
    name: "WorkFlow Champion",
    tagline: "팀 협업을 위한 스마트 작업 관리 도구",
    description: "Kanban 보드, Gantt 차트, 시간 추적을 하나의 플랫폼에서 제공합니다. Slack, GitHub와 원활하게 통합됩니다.",
    website_url: "https://example.com/taskmaster",
    logo_url: "https://via.placeholder.com/100/3F51B5/ffffff?text=TM",
    cover_url: "https://via.placeholder.com/800x400/3F51B5/ffffff?text=TaskMaster",
    pricing_info: "무료, 팀 $12/사용자/월",
    status: :live,
    featured: true,
    topics: [:productivity, :development],
    launch_offset: -2, # 2 days ago
    votes: 63,
    likes: 44,
    comments: 19,
    company_name: "ProductivityHub",
    founded_year: 2021,
    headquarters: "Austin, TX",
    employee_count: "51-100"
  },

  # Last Week Products (10 products)
  {
    name: "CineClip AI",
    tagline: "AI로 영상 편집을 자동화하는 도구",
    description: "자동 자막 생성, 장면 감지, 하이라이트 추출을 AI가 처리합니다. 전문가 수준의 영상을 몇 분 만에 제작할 수 있습니다.",
    website_url: "https://example.com/videoedit",
    logo_url: "https://via.placeholder.com/100/FF6B6B/ffffff?text=VE",
    cover_url: "https://via.placeholder.com/800x400/FF6B6B/ffffff?text=VideoEdit",
    pricing_info: "$19/월",
    status: :live,
    featured: false,
    topics: [:ai, :design],
    launch_offset: -8, # 8 days ago
    votes: 72,
    likes: 51,
    comments: 22,
    company_name: "MediaAI Inc.",
    founded_year: 2022,
    headquarters: "Los Angeles, CA",
    employee_count: "11-50"
  },
  {
    name: "ReviewMate AI",
    tagline: "24/7 작동하는 AI 코드 리뷰어",
    description: "Pull Request를 자동으로 분석하고 버그, 보안 이슈, 코드 스타일 문제를 찾아냅니다. GitHub, GitLab과 통합됩니다.",
    website_url: "https://example.com/codereview",
    logo_url: "https://via.placeholder.com/100/00BCD4/ffffff?text=CR",
    cover_url: "https://via.placeholder.com/800x400/00BCD4/ffffff?text=CodeReview",
    pricing_info: "무료, 팀 $49/월",
    status: :live,
    featured: true,
    topics: [:development, :ai],
    launch_offset: -7, # 7 days ago
    votes: 85,
    likes: 58,
    comments: 27,
    company_name: "DevTools AI",
    founded_year: 2023,
    headquarters: "Seattle, WA"
  },
  {
    name: "ZenPath Meditation",
    tagline: "일상 속 명상과 마음챙김 가이드",
    description: "과학 기반의 명상 프로그램으로 스트레스를 관리하고 정신 건강을 개선합니다. 수면, 불안, 집중력 향상 등 다양한 프로그램을 제공합니다.",
    website_url: "https://example.com/mindful",
    logo_url: "https://via.placeholder.com/100/9C27B0/ffffff?text=MM",
    cover_url: "https://via.placeholder.com/800x400/9C27B0/ffffff?text=Mindful",
    pricing_info: "무료, 프리미엄 $11.99/월",
    status: :live,
    featured: false,
    topics: [:health, :productivity],
    launch_offset: -9, # 9 days ago
    votes: 44,
    likes: 29,
    comments: 10,
    company_name: "Wellness Tech",
    founded_year: 2021,
    headquarters: "Portland, OR"
  },
  {
    name: "WealthWise Invest",
    tagline: "초보자를 위한 쉬운 투자 플랫폼",
    description: "자동 포트폴리오 구성, 리밸런싱, 세금 최적화를 제공합니다. 적은 금액으로도 분산 투자를 시작할 수 있습니다.",
    website_url: "https://example.com/investsmart",
    logo_url: "https://via.placeholder.com/100/4CAF50/ffffff?text=IS",
    cover_url: "https://via.placeholder.com/800x400/4CAF50/ffffff?text=InvestSmart",
    pricing_info: "무료, 프리미엄 $5/월",
    status: :live,
    featured: true,
    topics: [:finance, :ai],
    launch_offset: -10, # 10 days ago
    votes: 61,
    likes: 39,
    comments: 17,
    company_name: "FinanceFirst Ltd.",
    founded_year: 2022,
    headquarters: "Hong Kong",
    employee_count: "51-100"
  },
  {
    name: "LearnRoute AI",
    tagline: "AI 기반 맞춤형 학습 로드맵 생성",
    description: "목표와 현재 수준을 분석하여 최적의 학습 경로를 추천합니다. 무료 및 유료 리소스를 큐레이션하여 제공합니다.",
    website_url: "https://example.com/skillpath",
    logo_url: "https://via.placeholder.com/100/FF9800/ffffff?text=SP",
    cover_url: "https://via.placeholder.com/800x400/FF9800/ffffff?text=SkillPath",
    pricing_info: "무료",
    status: :live,
    featured: false,
    topics: [:education, :ai],
    launch_offset: -11, # 11 days ago
    votes: 37,
    likes: 24,
    comments: 8,
    company_name: "LearningAI Co.",
    founded_year: 2023,
    headquarters: "Dublin, Ireland"
  },
  {
    name: "RetailBoost Pro",
    tagline: "데이터 기반 온라인 스토어 최적화",
    description: "A/B 테스팅, 전환율 분석, 장바구니 이탈 방지 등 이커머스 성공을 위한 모든 도구를 제공합니다.",
    website_url: "https://example.com/storeoptimizer",
    logo_url: "https://via.placeholder.com/100/E91E63/ffffff?text=SO",
    cover_url: "https://via.placeholder.com/800x400/E91E63/ffffff?text=StoreOptimizer",
    pricing_info: "$79/월",
    status: :live,
    featured: false,
    topics: [:ecommerce, :productivity],
    launch_offset: -12, # 12 days ago
    votes: 33,
    likes: 21,
    comments: 7,
    company_name: "eCommerce Tools",
    founded_year: 2021,
    headquarters: "Sydney, Australia",
    employee_count: "11-50"
  },
  {
    name: "QuickAPI Builder",
    tagline: "노코드로 REST API 만들기",
    description: "코딩 없이 드래그 앤 드롭으로 강력한 REST API를 구축합니다. 데이터베이스, 인증, 배포까지 모든 것을 자동화합니다.",
    website_url: "https://example.com/apibuilder",
    logo_url: "https://via.placeholder.com/100/673AB7/ffffff?text=AB",
    cover_url: "https://via.placeholder.com/800x400/673AB7/ffffff?text=APIBuilder",
    pricing_info: "무료, 프로 $29/월",
    status: :live,
    featured: true,
    topics: [:development, :productivity],
    launch_offset: -8, # 8 days ago
    votes: 79,
    likes: 54,
    comments: 24,
    company_name: "NoCode Solutions",
    founded_year: 2022,
    headquarters: "Vancouver, Canada"
  },
  {
    name: "TokenVault Design",
    tagline: "디자인 토큰 관리를 위한 중앙 플랫폼",
    description: "색상, 타이포그래피, 간격 등 디자인 토큰을 한 곳에서 관리하고 모든 플랫폼에 동기화합니다.",
    website_url: "https://example.com/designtokens",
    logo_url: "https://via.placeholder.com/100/00BCD4/ffffff?text=DT",
    cover_url: "https://via.placeholder.com/800x400/00BCD4/ffffff?text=DesignTokens",
    pricing_info: "무료, 팀 $19/월",
    status: :live,
    featured: false,
    topics: [:design, :development],
    launch_offset: -9, # 9 days ago
    votes: 42,
    likes: 28,
    comments: 11,
    company_name: "DesignOps Inc.",
    founded_year: 2023,
    headquarters: "Copenhagen, Denmark"
  },
  {
    name: "PowerFit AI Coach",
    tagline: "개인 AI 피트니스 트레이너",
    description: "운동 동작을 실시간으로 분석하고 교정합니다. 체력 수준과 목표에 맞는 맞춤형 운동 프로그램을 제공합니다.",
    website_url: "https://example.com/fitcoach",
    logo_url: "https://via.placeholder.com/100/FF5722/ffffff?text=FC",
    cover_url: "https://via.placeholder.com/800x400/FF5722/ffffff?text=FitCoach",
    pricing_info: "$14.99/월",
    status: :live,
    featured: true,
    topics: [:health, :ai],
    launch_offset: -10, # 10 days ago
    votes: 68,
    likes: 46,
    comments: 20,
    company_name: "FitnessAI Corp.",
    founded_year: 2022,
    headquarters: "Miami, FL",
    employee_count: "11-50"
  },
  {
    name: "CoinWatch Portfolio",
    tagline: "올인원 암호화폐 포트폴리오 관리",
    description: "100개 이상의 거래소 연동, 실시간 가격 추적, 세금 리포트 자동 생성 기능을 제공합니다.",
    website_url: "https://example.com/cryptotracker",
    logo_url: "https://via.placeholder.com/100/FFC107/ffffff?text=CT",
    cover_url: "https://via.placeholder.com/800x400/FFC107/ffffff?text=CryptoTracker",
    pricing_info: "무료, 프로 $9.99/월",
    status: :live,
    featured: false,
    topics: [:finance, :productivity],
    launch_offset: -13, # 13 days ago
    votes: 54,
    likes: 36,
    comments: 15,
    company_name: "CryptoTools Ltd.",
    founded_year: 2021,
    headquarters: "Zurich, Switzerland",
    employee_count: "11-50"
  }
]

puts "🚀 Creating #{products_data.length} products..."

created_count = 0
products_data.each_with_index do |data, index|
  begin
    # Calculate launch date
    launch_date = Date.current + data[:launch_offset].days

    # Create product
    product = Product.new(
      name: data[:name],
      tagline: data[:tagline],
      description: data[:description],
      website_url: data[:website_url],
      logo_url: data[:logo_url],
      cover_url: data[:cover_url],
      pricing_info: data[:pricing_info],
      status: data[:status],
      featured: data[:featured],
      user: user,
      company_name: data[:company_name],
      founded_year: data[:founded_year],
      headquarters: data[:headquarters],
      employee_count: data[:employee_count]
    )

    # Skip validation for seed data
    product.save(validate: false)

    # Create launch record manually
    Launch.create!(
      product: product,
      launch_date: launch_date,
      region: 'kr',
      status: :live
    )

    # Add topics
    data[:topics].each do |topic_key|
      topic = topics[topic_key]
      product.topics << topic if topic
    end

    # Create votes
    data[:votes].times do |i|
      Vote.create!(
        user: user,
        product: product,
        weight: 1
      ) rescue nil # Skip if duplicate
    end

    # Create likes
    data[:likes].times do |i|
      Like.create!(
        user: user,
        product: product
      ) rescue nil # Skip if duplicate
    end

    # Create comments
    data[:comments].times do |i|
      comment = Comment.new(
        user: user,
        product: product,
        content: "이 제품 정말 유용하네요! #{i+1}번째 댓글입니다. 특히 이 기능이 마음에 듭니다."
      )
      comment.save(validate: false)
    end

    # Update counter caches
    product.update_columns(
      votes_count: data[:votes],
      likes_count: data[:likes],
      comments_count: data[:comments]
    )

    created_count += 1
    puts "  ✓ [#{index + 1}/#{products_data.length}] #{product.name}"

  rescue => e
    puts "  ✗ [#{index + 1}/#{products_data.length}] Failed to create #{data[:name]}: #{e.message}"
  end
end

puts "\n✅ Seed script completed!"
puts "📊 Created #{created_count} out of #{products_data.length} products"
puts "🎉 Done!"
