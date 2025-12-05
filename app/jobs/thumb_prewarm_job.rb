class ThumbPrewarmJob < ApplicationJob
  queue_as :default
  
  def perform(product_id)
    product = Product.find_by(id: product_id)
    return unless product&.logo_image&.attached?
    
    # Generate thumbnail variants to preprocess them
    begin
      product.logo_thumb_1x
      product.logo_thumb_2x
      Rails.logger.info "Prewarmed thumbnails for Product #{product_id}"
    rescue => e
      Rails.logger.error "Failed to prewarm thumbnails for Product #{product_id}: #{e.message}"
    end
  end
end