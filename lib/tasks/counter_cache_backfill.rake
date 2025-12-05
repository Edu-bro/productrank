namespace :counter_cache do
  desc "Backfill counter cache columns for existing products"
  task backfill: :environment do
    puts "Starting counter cache backfill for #{Product.count} products..."
    
    # Reset all counters to ensure accuracy
    Product.find_each do |product|
      print "."
      
      # Count and update votes
      votes_count = product.votes.sum(:weight) || 0
      product.update_column(:votes_count, votes_count)
      
      # Count and update likes  
      likes_count = product.likes.count || 0
      product.update_column(:likes_count, likes_count)
      
      # Count and update comments
      comments_count = product.comments.count || 0
      product.update_column(:comments_count, comments_count)
    end
    
    puts "\nBackfill completed successfully!"
    puts "Verification:"
    puts "- Products: #{Product.count}"
    puts "- Total votes: #{Product.sum(:votes_count)}"
    puts "- Total likes: #{Product.sum(:likes_count)}"
    puts "- Total comments: #{Product.sum(:comments_count)}"
  end
  
  desc "Verify counter cache accuracy"
  task verify: :environment do
    puts "Verifying counter cache accuracy..."
    
    mismatches = 0
    
    Product.find_each do |product|
      actual_votes = product.votes.sum(:weight) || 0
      actual_likes = product.likes.count || 0
      actual_comments = product.comments.count || 0
      
      if product.votes_count != actual_votes
        puts "MISMATCH: Product #{product.id} votes_count=#{product.votes_count}, actual=#{actual_votes}"
        mismatches += 1
      end
      
      if product.likes_count != actual_likes
        puts "MISMATCH: Product #{product.id} likes_count=#{product.likes_count}, actual=#{actual_likes}"
        mismatches += 1
      end
      
      if product.comments_count != actual_comments
        puts "MISMATCH: Product #{product.id} comments_count=#{product.comments_count}, actual=#{actual_comments}"
        mismatches += 1
      end
    end
    
    if mismatches == 0
      puts "✅ All counter caches are accurate!"
    else
      puts "❌ Found #{mismatches} mismatches. Run 'rake counter_cache:backfill' to fix."
    end
  end
end