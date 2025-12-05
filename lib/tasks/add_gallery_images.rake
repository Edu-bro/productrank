require 'net/http'
require 'uri'

namespace :images do
  desc "Add gallery images with working URLs"
  task add_gallery: :environment do
    puts "Adding gallery images to products..."
    
    # 실제 작동하는 Unsplash 이미지 URL들
    gallery_image_sets = {
      'ai' => [
        'https://images.unsplash.com/photo-1555255707-c07966088b7b?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&h=350&fit=crop&auto=format'
      ],
      'productivity' => [
        'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=500&h=350&fit=crop&auto=format'
      ],
      'design' => [
        'https://images.unsplash.com/photo-1541462608143-67571c6738dd?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1503149779833-1de50ebe5f52?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1558655146-364adaf1fcc9?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1609921212029-bb5a28e60960?w=500&h=350&fit=crop&auto=format'
      ],
      'development' => [
        'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=500&h=350&fit=crop&auto=format'
      ],
      'health' => [
        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500&h=350&fit=crop&auto=format'
      ],
      'finance' => [
        'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1567427017947-545c5f8d16ad?w=500&h=350&fit=crop&auto=format'
      ],
      'education' => [
        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=500&h=350&fit=crop&auto=format'
      ],
      'default' => [
        'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1531297484001-80022131f5a1?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1526378800651-c32d170fe6f8?w=500&h=350&fit=crop&auto=format',
        'https://images.unsplash.com/photo-1563206767-5b18f218e8de?w=500&h=350&fit=crop&auto=format'
      ]
    }
    
    Product.find_each do |product|
      next if product.gallery_images_files.attached?
      
      puts "Adding gallery images for: #{product.name}"
      
      # 제품 토픽에 따라 적절한 이미지 세트 선택
      topic_name = product.topics.first&.name&.downcase
      image_set = case topic_name
                  when /ai|artificial|intelligence|인공지능/
                    gallery_image_sets['ai']
                  when /productivity|생산성/
                    gallery_image_sets['productivity']
                  when /design|디자인/
                    gallery_image_sets['design']
                  when /development|개발|programming/
                    gallery_image_sets['development']
                  when /health|건강|fitness/
                    gallery_image_sets['health']
                  when /finance|금융|fintech/
                    gallery_image_sets['finance']
                  when /education|교육/
                    gallery_image_sets['education']
                  else
                    gallery_image_sets['default']
                  end
      
      # 4개의 갤러리 이미지 다운로드 및 첨부
      image_set.each_with_index do |url, index|
        begin
          download_and_attach_gallery_image(url, product, index + 1)
        rescue => e
          puts "  ✗ Error downloading gallery image #{index + 1}: #{e.message}"
        end
      end
      
      puts "✓ Completed gallery for: #{product.name}"
    end
    
    puts "Gallery images addition completed!"
  end
  
  private
  
  def download_and_attach_gallery_image(url, product, index)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    
    response = http.get(uri.path + (uri.query ? "?#{uri.query}" : ""))
    
    if response.code == '200'
      filename = "#{product.name.gsub(/[^0-9A-Za-z.\-]/, '_')}_gallery_#{index}.jpg"
      
      temp_file = Tempfile.new([filename, '.jpg'])
      temp_file.binmode
      temp_file.write(response.body)
      temp_file.rewind
      
      product.gallery_images_files.attach(
        io: temp_file,
        filename: filename,
        content_type: 'image/jpeg'
      )
      
      temp_file.close
      temp_file.unlink
      
      puts "    ✓ Downloaded gallery image #{index}: #{filename}"
    else
      puts "    ✗ Failed to download gallery image #{index}: HTTP #{response.code}"
    end
  end
end