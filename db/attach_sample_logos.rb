# Attach Real Logo Images to Sample Products
# Uses real logo URLs from companies to attach as ActiveStorage files

require 'open-uri'
require 'tempfile'

puts "📸 샘플 제품에 실제 로고 이미지 첨부 중..."
puts

# Sample products with real company logos
products_with_logos = {
  "NeuralWrite Pro" => "https://logo.clearbit.com/openai.com",
  "DataFlow Analytics" => "https://logo.clearbit.com/tableau.com",
  "MoodTrack Wellness" => "https://logo.clearbit.com/calm.com",
  "CodeGenius AI" => "https://logo.clearbit.com/github.com",
  "BrainBoost Focus" => "https://logo.clearbit.com/notion.so",
  "SystemKit Designer" => "https://logo.clearbit.com/figma.com",
  "VitalCare AI" => "https://logo.clearbit.com/apple.com",
  "MoneyMind Pro" => "https://logo.clearbit.com/mint.com",
  "SkillForge Academy" => "https://logo.clearbit.com/udemy.com",
  "CommerceBoost AI" => "https://logo.clearbit.com/shopify.com",
  "DocuMatic Pro" => "https://logo.clearbit.com/readme.com",
  "HueHarmony AI" => "https://logo.clearbit.com/adobe.com",
  "WorkFlow Champion" => "https://logo.clearbit.com/asana.com",
  "CineClip AI" => "https://logo.clearbit.com/adobe.com",
  "ReviewMate AI" => "https://logo.clearbit.com/gitlab.com",
  "ZenPath Meditation" => "https://logo.clearbit.com/headspace.com",
  "WealthWise Invest" => "https://logo.clearbit.com/robinhood.com",
  "LearnRoute AI" => "https://logo.clearbit.com/coursera.org",
  "RetailBoost Pro" => "https://logo.clearbit.com/bigcommerce.com",
  "QuickAPI Builder" => "https://logo.clearbit.com/postman.com",
  "TokenVault Design" => "https://logo.clearbit.com/zeroheight.com",
  "PowerFit AI Coach" => "https://logo.clearbit.com/strava.com",
  "CoinWatch Portfolio" => "https://logo.clearbit.com/coinbase.com"
}

success_count = 0
fail_count = 0

products_with_logos.each do |product_name, logo_url|
  product = Product.find_by(name: product_name)

  unless product
    puts "  ⚠️  Product not found: #{product_name}"
    fail_count += 1
    next
  end

  begin
    # Download the image
    puts "  📥 Downloading logo for #{product_name}..."

    downloaded_image = URI.open(logo_url, "User-Agent" => "Mozilla/5.0")

    # Create a tempfile
    tempfile = Tempfile.new([product_name.parameterize, '.png'])
    tempfile.binmode
    tempfile.write(downloaded_image.read)
    tempfile.rewind

    # Attach to product
    product.logo_image.attach(
      io: File.open(tempfile.path),
      filename: "#{product_name.parameterize}_logo.png",
      content_type: 'image/png'
    )

    # Also set logo_url for fallback
    product.update_column(:logo_url, logo_url)

    tempfile.close
    tempfile.unlink

    success_count += 1
    puts "  ✓ #{product_name} - Logo attached successfully"

  rescue => e
    puts "  ✗ #{product_name} - Failed: #{e.message}"
    fail_count += 1
  end

  # Small delay to avoid rate limiting
  sleep(0.5)
end

puts
puts "✅ Logo attachment completed!"
puts "📊 Success: #{success_count}, Failed: #{fail_count}"
puts "🎉 Done!"
