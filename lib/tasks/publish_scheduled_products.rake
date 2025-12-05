namespace :products do
  desc "Publish scheduled products whose launch date has arrived"
  task publish_scheduled: :environment do
    puts "Checking for scheduled products to publish..."
    
    scheduled_products = Product.where(status: :scheduled)
                               .where('launch_date <= ?', Time.current)
    
    if scheduled_products.any?
      scheduled_products.each do |product|
        product.update!(status: :live)
        
        # Launch 상태도 업데이트
        product.launches.where(status: :scheduled).update_all(status: :live)
        
        puts "✓ Published: #{product.name} (scheduled for #{product.launch_date})"
      end
      
      puts "#{scheduled_products.count} products published successfully!"
    else
      puts "No products to publish at this time."
    end
  end
end