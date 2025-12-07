namespace :products do
  desc "Attach sample images to products that don't have images"
  task attach_sample_images: :environment do
    require 'open-uri'

    puts "Checking products without images..."

    products_without_images = Product.all.select { |p| !p.product_images.attached? }

    puts "Found #{products_without_images.count} products without images"

    # Sample Unsplash images (placeholder URLs)
    sample_images = [
      'https://images.unsplash.com/photo-1498050108023-c5249f4df085', # Computer/Tech
      'https://images.unsplash.com/photo-1488590528505-98d2b5aba04b', # Laptop
      'https://images.unsplash.com/photo-1461749280684-dccba630e2f6', # Code
      'https://images.unsplash.com/photo-1517694712202-14dd9538aa97', # MacBook
      'https://images.unsplash.com/photo-1460925895917-afdab827c52f', # Data viz
      'https://images.unsplash.com/photo-1551288049-bebda4e38f71', # Analytics
      'https://images.unsplash.com/photo-1504868584819-f8e8b4b6d7e3', # Mobile
      'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c', # AI/Tech
      'https://images.unsplash.com/photo-1519389950473-47ba0277781c', # Team work
      'https://images.unsplash.com/photo-1557804506-669a67965ba0', # Office
    ]

    logo_images = [
      'https://images.unsplash.com/photo-1614680376593-902f74cf0d41', # Abstract 1
      'https://images.unsplash.com/photo-1614680376408-81e0bc39bc5a', # Abstract 2
      'https://images.unsplash.com/photo-1614680376573-df3480f0c6ff', # Abstract 3
      'https://images.unsplash.com/photo-1614680376739-414d95ff43df', # Abstract 4
      'https://images.unsplash.com/photo-1614680376739-414d95ff43df', # Abstract 5
    ]

    products_without_images.each_with_index do |product, index|
      puts "\nProcessing: #{product.name} (ID: #{product.id})"

      begin
        # Attach product images (2-3 images per product)
        num_images = rand(2..3)
        num_images.times do |i|
          image_url = sample_images[index % sample_images.length] + "?w=800&h=600&fit=crop&q=80&auto=format&#{i}"

          begin
            file = URI.open(image_url)
            product.product_images.attach(
              io: file,
              filename: "product_#{product.id}_image_#{i + 1}.jpg",
              content_type: 'image/jpeg'
            )
            puts "  ✓ Attached product image #{i + 1}"
          rescue => e
            puts "  ✗ Failed to attach product image #{i + 1}: #{e.message}"
          end
        end

        # Attach logo image
        logo_url = logo_images[index % logo_images.length] + "?w=400&h=400&fit=crop&q=80&auto=format"

        begin
          logo_file = URI.open(logo_url)
          product.logo_image.attach(
            io: logo_file,
            filename: "logo_#{product.id}.jpg",
            content_type: 'image/jpeg'
          )
          puts "  ✓ Attached logo image"
        rescue => e
          puts "  ✗ Failed to attach logo image: #{e.message}"
        end

        puts "  ✓ Product updated successfully"

      rescue => e
        puts "  ✗ Error processing product: #{e.message}"
      end

      # Sleep to avoid rate limiting
      sleep(0.5)
    end

    puts "\n✓ Done! Processed #{products_without_images.count} products"
  end
end
