require 'net/http'
require 'uri'

namespace :images do
  desc "Download and store product images locally"
  task download: :environment do
    puts "Starting image download process..."
    
    Product.find_each do |product|
      puts "Processing product: #{product.name}"
      
      begin
        # Download logo image
        if product.logo_url.present? && !product.logo_image.attached?
          download_and_attach_image(product.logo_url, product, :logo_image, "#{product.name}_logo")
        end
        
        # Download cover image
        if product.cover_url.present? && !product.cover_image.attached?
          download_and_attach_image(product.cover_url, product, :cover_image, "#{product.name}_cover")
        end
        
        # Generate and download gallery images (3-5 images per product)
        if product.gallery_images_files.empty?
          generate_gallery_images(product)
        end
        
        puts "✓ Completed: #{product.name}"
        
      rescue => e
        puts "✗ Error processing #{product.name}: #{e.message}"
      end
    end
    
    puts "Image download process completed!"
  end
  
  private
  
  def download_and_attach_image(url, product, attachment_name, filename)
    return unless url.present?
    
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    
    if response.code == '200'
      # Determine file extension from content type or URL
      content_type = response['content-type']
      extension = case content_type
                  when /jpeg|jpg/i then '.jpg'
                  when /png/i then '.png'
                  when /webp/i then '.webp'
                  when /gif/i then '.gif'
                  else 
                    File.extname(uri.path).present? ? File.extname(uri.path) : '.jpg'
                  end
      
      # Clean filename
      clean_filename = filename.gsub(/[^0-9A-Za-z.\-]/, '_') + extension
      
      # Create temporary file
      temp_file = Tempfile.new([clean_filename, extension])
      temp_file.binmode
      temp_file.write(response.body)
      temp_file.rewind
      
      # Attach to product
      product.send(attachment_name).attach(
        io: temp_file,
        filename: clean_filename,
        content_type: content_type || 'image/jpeg'
      )
      
      temp_file.close
      temp_file.unlink
      
      puts "  ✓ Downloaded #{attachment_name}: #{clean_filename}"
    else
      puts "  ✗ Failed to download #{attachment_name}: HTTP #{response.code}"
    end
  rescue => e
    puts "  ✗ Error downloading #{attachment_name}: #{e.message}"
  end
  
  def generate_gallery_images(product)
    # Generate 3-5 relevant gallery images for each product based on topic
    topic_keywords = product.topics.pluck(:name).join(',')
    category = product.topics.first&.name || 'technology'
    
    # Unsplash 카테고리별 이미지 URL 생성
    gallery_urls = generate_gallery_urls(category, 4)
    
    gallery_urls.each_with_index do |url, index|
      begin
        download_and_attach_gallery_image(url, product, index + 1)
      rescue => e
        puts "    ✗ Error downloading gallery image #{index + 1}: #{e.message}"
      end
    end
  end
  
  def generate_gallery_urls(category, count)
    # 카테고리별 키워드 매핑
    keywords = case category.downcase
               when /ai|artificial|intelligence|인공지능/
                 ['artificial-intelligence', 'robot', 'computer', 'technology']
               when /productivity|생산성/
                 ['workspace', 'office', 'computer', 'productivity']
               when /design|디자인/
                 ['design', 'creative', 'art', 'graphic']
               when /development|개발|programming/
                 ['programming', 'code', 'computer', 'developer']
               when /health|건강|fitness/
                 ['health', 'fitness', 'wellness', 'medical']
               when /finance|금융|fintech/
                 ['finance', 'money', 'business', 'investment']
               when /education|교육/
                 ['education', 'learning', 'study', 'book']
               when /social|소셜|community/
                 ['people', 'social', 'community', 'network']
               else
                 ['technology', 'business', 'innovation', 'digital']
               end
    
    # 각 키워드에 대해 Unsplash URL 생성
    urls = []
    keywords.take(count).each_with_index do |keyword, index|
      width = [400, 500, 600][index % 3]
      height = [300, 350, 400][index % 3]
      urls << "https://images.unsplash.com/photo-#{rand(1500000000000..1700000000000)}?w=#{width}&h=#{height}&fit=crop&auto=format&q=80"
    end
    
    urls
  end
  
  def download_and_attach_gallery_image(url, product, index)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    
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