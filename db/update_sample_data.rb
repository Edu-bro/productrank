# Update Sample Data Script
# Adds votes, likes, and comments to existing products

puts "📝 Updating sample data for existing products..."

# Get or create users for voting/liking
users = []
100.times do |i|
  user = User.find_or_create_by(username: "demo_user_#{i}") do |u|
    u.email = "demo#{i}@example.com"
    u.name = "Demo User #{i}"
    u.role = 0
    u.reputation = 10
  end
  users << user
end

main_user = User.first || users.first
puts "✅ Created/found #{users.length} users for engagement"

# Product data with stats
products_stats = {
  "CodeGenius AI" => { votes: 45, likes: 28, comments: 12 },
  "BrainBoost Focus" => { votes: 67, likes: 42, comments: 18 },
  "SystemKit Designer" => { votes: 38, likes: 25, comments: 8 },
  "VitalCare AI" => { votes: 52, likes: 35, comments: 14 },
  "MoneyMind Pro" => { votes: 29, likes: 18, comments: 6 },
  "SkillForge Academy" => { votes: 34, likes: 22, comments: 9 },
  "CommerceBoost AI" => { votes: 56, likes: 38, comments: 16 },
  "DocuMatic Pro" => { votes: 41, likes: 27, comments: 11 },
  "HueHarmony AI" => { votes: 48, likes: 31, comments: 13 },
  "WorkFlow Champion" => { votes: 63, likes: 44, comments: 19 },
  "CineClip AI" => { votes: 72, likes: 51, comments: 22 },
  "ReviewMate AI" => { votes: 85, likes: 58, comments: 27 },
  "ZenPath Meditation" => { votes: 44, likes: 29, comments: 10 },
  "WealthWise Invest" => { votes: 61, likes: 39, comments: 17 },
  "LearnRoute AI" => { votes: 37, likes: 24, comments: 8 },
  "RetailBoost Pro" => { votes: 33, likes: 21, comments: 7 },
  "QuickAPI Builder" => { votes: 79, likes: 54, comments: 24 },
  "TokenVault Design" => { votes: 42, likes: 28, comments: 11 },
  "PowerFit AI Coach" => { votes: 68, likes: 46, comments: 20 },
  "CoinWatch Portfolio" => { votes: 54, likes: 36, comments: 15 }
}

updated_count = 0

products_stats.each do |product_name, stats|
  product = Product.find_by(name: product_name)

  unless product
    puts "  ⚠️  Product not found: #{product_name}"
    next
  end

  begin
    # Clear existing votes, likes, and comments for this product
    product.votes.destroy_all
    product.likes.destroy_all
    product.comments.destroy_all

    # Create votes from different users
    stats[:votes].times do |i|
      Vote.create!(
        user: users[i % users.length],
        product: product,
        weight: 1
      ) rescue nil
    end

    # Create likes from different users
    stats[:likes].times do |i|
      Like.create!(
        user: users[i % users.length],
        product: product
      ) rescue nil
    end

    # Create comments from different users (with longer text to pass validation)
    stats[:comments].times do |i|
      comment = Comment.new(
        user: users[i % users.length],
        product: product,
        content: "이 제품 정말 유용하네요! #{i+1}번째 댓글입니다. 특히 이 기능이 마음에 듭니다. 앞으로도 계속 사용할 것 같아요."
      )
      comment.save(validate: false)
    end

    # Update counter caches
    product.update_columns(
      votes_count: Vote.where(product: product).count,
      likes_count: Like.where(product: product).count,
      comments_count: Comment.where(product: product).count
    )

    updated_count += 1
    puts "  ✓ Updated #{product_name} (votes: #{product.votes_count}, likes: #{product.likes_count}, comments: #{product.comments_count})"

  rescue => e
    puts "  ✗ Failed to update #{product_name}: #{e.message}"
  end
end

puts "\n✅ Update completed!"
puts "📊 Updated #{updated_count} out of #{products_stats.length} products"
puts "🎉 Done!"
