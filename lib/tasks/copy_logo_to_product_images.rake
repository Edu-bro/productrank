namespace :products do
  desc "Copy logo_image to product_images for products without product images"
  task copy_logo_to_product_images: :environment do
    puts "Starting to copy logo images to product images..."

    products = Product.all
    success_count = 0
    fail_count = 0

    products.each do |product|
      # Skip if product already has product_images
      if product.product_images.attached?
        puts "⏩ Product ##{product.id} (#{product.name}) already has product images. Skipping..."
        next
      end

      # Skip if product doesn't have logo_image
      unless product.logo_image.attached?
        puts "⚠️  Product ##{product.id} (#{product.name}) doesn't have logo_image. Skipping..."
        fail_count += 1
        next
      end

      begin
        # Copy logo_image blob to product_images
        blob = product.logo_image.blob

        product.product_images.attach(
          io: StringIO.new(blob.download),
          filename: blob.filename.to_s,
          content_type: blob.content_type
        )

        puts "✓ Product ##{product.id} (#{product.name}): Copied logo to product_images"
        success_count += 1

      rescue => e
        puts "✗ Product ##{product.id} (#{product.name}): Error - #{e.message}"
        fail_count += 1
      end
    end

    puts "\n" + "="*60
    puts "Summary:"
    puts "  ✓ Successfully processed: #{success_count} products"
    puts "  ✗ Failed/Skipped: #{fail_count} products"
    puts "="*60
  end
end
