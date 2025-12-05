# Fix Launch Dates Script
# Updates past launch dates to be properly distributed across this week and last week

puts "🔧 Fixing launch dates..."

today = Date.current
puts "📅 Today's date: #{today}"

# Products to update with correct dates
# This week: -1, -2, -3 days (yesterday, 2 days ago, 3 days ago)
# Last week: -7, -8, -9, -10, -11, -12, -13 days

updates = [
  # This week products (should appear in "저번주 랭크보드")
  { name: "BrainBoost Focus", days_ago: 1 },          # Yesterday
  { name: "CodeGenius AI", days_ago: 2 },             # 2 days ago
  { name: "SystemKit Designer", days_ago: 3 },        # 3 days ago
  { name: "VitalCare AI", days_ago: 1 },              # Yesterday
  { name: "MoneyMind Pro", days_ago: 4 },             # 4 days ago
  { name: "SkillForge Academy", days_ago: 2 },        # 2 days ago
  { name: "CommerceBoost AI", days_ago: 1 },          # Yesterday
  { name: "DocuMatic Pro", days_ago: 3 },             # 3 days ago
  { name: "HueHarmony AI", days_ago: 5 },             # 5 days ago
  { name: "WorkFlow Champion", days_ago: 2 },         # 2 days ago

  # Last week products (should appear in "저번주 랭크보드" and "저번달 랭크보드")
  { name: "CineClip AI", days_ago: 8 },               # 8 days ago
  { name: "ReviewMate AI", days_ago: 7 },             # 7 days ago (exactly 1 week)
  { name: "ZenPath Meditation", days_ago: 9 },        # 9 days ago
  { name: "WealthWise Invest", days_ago: 10 },        # 10 days ago
  { name: "LearnRoute AI", days_ago: 11 },            # 11 days ago
  { name: "RetailBoost Pro", days_ago: 12 },          # 12 days ago
  { name: "QuickAPI Builder", days_ago: 8 },          # 8 days ago
  { name: "TokenVault Design", days_ago: 9 },         # 9 days ago
  { name: "PowerFit AI Coach", days_ago: 10 },        # 10 days ago
  { name: "CoinWatch Portfolio", days_ago: 13 }       # 13 days ago (almost 2 weeks)
]

updated_count = 0

updates.each do |update|
  product = Product.find_by(name: update[:name])

  unless product
    puts "  ⚠️  Product not found: #{update[:name]}"
    next
  end

  launch = product.launches.first

  unless launch
    puts "  ⚠️  No launch record for: #{update[:name]}"
    next
  end

  new_date = today - update[:days_ago].days
  old_date = launch.launch_date.to_date

  launch.update!(launch_date: new_date)

  updated_count += 1
  puts "  ✓ #{product.name}: #{old_date} → #{new_date} (#{update[:days_ago]} days ago)"
end

puts "\n✅ Launch dates fixed!"
puts "📊 Updated #{updated_count} out of #{updates.length} products"
puts "\n📅 Distribution:"
puts "  - Today (#{today}): 3 products"
puts "  - This week (last 7 days): ~10 products"
puts "  - Last week (7-14 days ago): ~10 products"
puts "🎉 Done!"
