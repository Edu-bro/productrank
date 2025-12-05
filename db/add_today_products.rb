# Add Today's Products Script
# Adds 3 new products launching TODAY

puts "🚀 Adding today's products..."

# Get users
users = User.where("username LIKE 'demo_user_%'").to_a
if users.empty?
  puts "❌ No demo users found!"
  exit
end

main_user = User.first

# Get topics
topics = {
  ai: Topic.find_by(slug: 'ai'),
  productivity: Topic.find_by(slug: 'productivity'),
  design: Topic.find_by(slug: 'design'),
  development: Topic.find_by(slug: 'development'),
  health: Topic.find_by(slug: 'health'),
  finance: Topic.find_by(slug: 'finance')
}

# IMPORTANT: launch_date MUST be Date.current for today's products
today = Date.current
puts "📅 Today's date: #{today}"

# Today's products
today_products = [
  {
    name: "NeuralWrite Pro",
    tagline: "AI 기반 콘텐츠 작성 어시스턴트",
    description: "블로그 포스트, 마케팅 카피, 소셜 미디어 콘텐츠를 AI가 자동으로 작성합니다. SEO 최적화와 톤 앤 매너 조정 기능을 제공하여 브랜드 아이덴티티를 유지합니다.",
    website_url: "https://example.com/neuralwrite",
    logo_url: "https://via.placeholder.com/100/6366F1/ffffff?text=NW",
    cover_url: "https://via.placeholder.com/800x400/6366F1/ffffff?text=NeuralWrite",
    pricing_info: "무료, 프로 $19/월",
    status: :live,
    featured: true,
    topics: [:ai, :productivity],
    launch_date: today,  # TODAY!
    votes: 15,
    likes: 8,
    comments: 3,
    company_name: "ContentAI Labs",
    founded_year: 2024,
    headquarters: "Austin, TX",
    employee_count: "1-10"
  },
  {
    name: "DataFlow Analytics",
    tagline: "실시간 비즈니스 데이터 대시보드",
    description: "모든 비즈니스 데이터를 한눈에 볼 수 있는 직관적인 대시보드입니다. Google Analytics, Stripe, Salesforce 등 100개 이상의 서비스와 연동됩니다.",
    website_url: "https://example.com/dataflow",
    logo_url: "https://via.placeholder.com/100/10B981/ffffff?text=DF",
    cover_url: "https://via.placeholder.com/800x400/10B981/ffffff?text=DataFlow",
    pricing_info: "스타터 $29/월, 비즈니스 $99/월",
    status: :live,
    featured: true,
    topics: [:productivity, :development],
    launch_date: today,  # TODAY!
    votes: 22,
    likes: 14,
    comments: 5,
    company_name: "DataTech Solutions",
    founded_year: 2023,
    headquarters: "San Francisco, CA",
    employee_count: "11-50"
  },
  {
    name: "MoodTrack Wellness",
    tagline: "감정 일기와 멘탈 헬스 트래커",
    description: "매일의 기분을 기록하고 패턴을 분석하여 정신 건강을 관리합니다. AI 기반 인사이트와 전문가의 웰니스 팁을 제공합니다.",
    website_url: "https://example.com/moodtrack",
    logo_url: "https://via.placeholder.com/100/EC4899/ffffff?text=MT",
    cover_url: "https://via.placeholder.com/800x400/EC4899/ffffff?text=MoodTrack",
    pricing_info: "무료, 프리미엄 $7.99/월",
    status: :live,
    featured: false,
    topics: [:health, :productivity],
    launch_date: today,  # TODAY!
    votes: 18,
    likes: 11,
    comments: 4,
    company_name: "MindWell Inc.",
    founded_year: 2024,
    headquarters: "Seattle, WA",
    employee_count: "1-10"
  }
]

created_count = 0

today_products.each_with_index do |data, index|
  begin
    # Check if product already exists
    if Product.exists?(name: data[:name])
      puts "  ⚠️  Product already exists: #{data[:name]}"
      next
    end

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
      user: main_user,
      company_name: data[:company_name],
      founded_year: data[:founded_year],
      headquarters: data[:headquarters],
      employee_count: data[:employee_count]
    )

    product.save(validate: false)

    # Create launch record with TODAY's date
    Launch.create!(
      product: product,
      launch_date: data[:launch_date],  # Use today's date
      region: 'kr',
      status: :live
    )

    # Add topics
    data[:topics].each do |topic_key|
      topic = topics[topic_key]
      product.topics << topic if topic
    end

    # Create votes from different users
    data[:votes].times do |i|
      Vote.create!(
        user: users[i % users.length],
        product: product,
        weight: 1
      ) rescue nil
    end

    # Create likes from different users
    data[:likes].times do |i|
      Like.create!(
        user: users[i % users.length],
        product: product
      ) rescue nil
    end

    # Create comments from different users
    data[:comments].times do |i|
      comment = Comment.new(
        user: users[i % users.length],
        product: product,
        content: "오늘 출시된 제품이네요! 정말 기대됩니다. #{i+1}번째로 사용해보고 싶어요. 특히 이 기능이 인상적입니다."
      )
      comment.save(validate: false)
    end

    # Update counter caches
    product.update_columns(
      votes_count: Vote.where(product: product).count,
      likes_count: Like.where(product: product).count,
      comments_count: Comment.where(product: product).count
    )

    created_count += 1
    puts "  ✓ [#{index + 1}/#{today_products.length}] #{product.name} (launched: #{data[:launch_date]})"

  rescue => e
    puts "  ✗ [#{index + 1}/#{today_products.length}] Failed to create #{data[:name]}: #{e.message}"
  end
end

puts "\n✅ Today's products added!"
puts "📊 Created #{created_count} out of #{today_products.length} products"
puts "📅 All products set to launch on: #{today}"
puts "🎉 Done!"
