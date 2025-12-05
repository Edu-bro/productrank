# 샘플 제품 데이터 생성 스크립트

# 카테고리 생성
productivity_topic = Topic.find_or_create_by(name: "생산성 도구") do |topic|
  topic.description = "업무 효율성을 높이는 도구들"
end

ai_topic = Topic.find_or_create_by(name: "AI 도구") do |topic|
  topic.description = "인공지능 기반 서비스들"
end

# Notion 제품 생성
notion = Product.find_or_create_by(name: "Notion") do |product|
  product.tagline = "올인원 워크스페이스로 노트, 작업, 데이터베이스를 하나로"
  product.description = <<~DESC
    Notion은 노트 작성, 작업 관리, 데이터베이스, 위키를 하나의 플랫폼에서 제공하는 올인원 워크스페이스입니다.
    
    개인 사용자부터 팀까지, 모든 정보를 체계적으로 정리하고 협업할 수 있는 강력한 도구입니다.
    
    • 블록 기반 에디터로 자유로운 문서 작성
    • 데이터베이스와 관계형 데이터 관리
    • 템플릿을 통한 빠른 페이지 생성
    • 실시간 협업 및 댓글 시스템
    • 다양한 뷰 (테이블, 보드, 캘린더, 갤러리)
    
    수백만 명의 사용자들이 Notion으로 더 체계적이고 효율적인 업무 환경을 만들어가고 있습니다.
  DESC
  product.website_url = "https://notion.so"
  product.logo_url = "https://logo.clearbit.com/notion.so"
  product.cover_url = "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=1200"
  product.gallery_urls = [
    "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=800",
    "https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=800",
    "https://images.unsplash.com/photo-1593063947394-b6683bee1af0?w=800",
    "https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?w=800"
  ].join(',')
  product.pricing_info = <<~PRICING
    개인 사용: 무료
    개인 프로: $5/월
    팀: $10/월 (사용자당)
    엔터프라이즈: 문의
  PRICING
  product.status = :live
  product.featured = true
end

# 런치 데이터 생성
Launch.find_or_create_by(product: notion) do |launch|
  launch.launch_date = 3.days.ago
  launch.status = :live
  launch.region = "global"
end

# 토픽 연결
ProductTopic.find_or_create_by(product: notion, topic: productivity_topic)
ProductTopic.find_or_create_by(product: notion, topic: ai_topic)

# 투표 생성 (샘플)
50.times do |i|
  user = User.find_or_create_by(email: "user#{i}@example.com") do |u|
    u.username = "user#{i}"
    u.name = "User #{i}"
    u.reputation = rand(100)
  end
  
  Vote.find_or_create_by(user: user, product: notion) do |vote|
    vote.weight = 1
  end
end

# 댓글 생성 (샘플)
10.times do |i|
  user = User.find_or_create_by(email: "commenter#{i}@example.com") do |u|
    u.username = "commenter#{i}"
    u.name = "Commenter #{i}"
    u.reputation = rand(100)
  end
  
  Comment.find_or_create_by(user: user, product: notion, content: "This is sample comment #{i+1}")
end

puts "샘플 데이터 생성 완료!"
puts "Product ID: #{notion.id}"
puts "Votes: #{notion.vote_count}"
puts "Comments: #{notion.comment_count}"