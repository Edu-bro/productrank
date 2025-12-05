Topic.create!([
  { name: "소셜미디어", slug: "social-media" },
  { name: "마케팅", slug: "marketing" },
  { name: "세일즈", slug: "sales" },
  { name: "고객지원", slug: "customer-support" },
  { name: "분석도구", slug: "analytics" },
  { name: "보안", slug: "security" },
  { name: "데이터베이스", slug: "database" },
  { name: "API도구", slug: "api-tools" },
  { name: "모바일앱", slug: "mobile-app" },
  { name: "웹개발", slug: "web-development" },
  { name: "게임", slug: "gaming" },
  { name: "음악", slug: "music" },
  { name: "영상편집", slug: "video-editing" },
  { name: "사진편집", slug: "photo-editing" },
  { name: "여행", slug: "travel" },
  { name: "부동산", slug: "real-estate" },
  { name: "법률", slug: "legal" },
  { name: "HR", slug: "hr" },
  { name: "회계", slug: "accounting" },
  { name: "프로젝트관리", slug: "project-management" }
])

puts "#{Topic.count} topics created successfully!"