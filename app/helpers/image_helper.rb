module ImageHelper
  # 환경별 이미지 URL 생성 (안정적이고 유지보수 가능)
  # Production: R2의 절대 URL
  # Development: 로컬의 상대 URL

  def image_url(attachment, only_path: nil)
    return nil unless attachment&.attached?

    # Determine path style based on environment
    use_only_path = only_path.nil? ? Rails.env.development? : only_path

    Rails.application.routes.url_helpers.rails_blob_path(
      attachment,
      only_path: use_only_path
    )
  end

  def product_logo_url(product)
    return nil unless product.logo_image.attached?

    image_url(product.logo_image)
  end

  def product_image_url(image)
    return nil unless image.is_a?(ActiveStorage::Attachment) || image.is_a?(ActiveStorage::Blob)

    attachment = image.is_a?(ActiveStorage::Blob) ? image : image.blob
    image_url(attachment)
  end

  def product_cover_image_url(product)
    return nil unless product.product_images.attached?

    image_url(product.product_images.first)
  end


  # 배치 처리 - 여러 이미지 URL 생성
  def product_image_urls(product)
    return [] unless product.product_images.attached?

    product.product_images.map { |image| image_url(image) }
  end

  # Fallback 이미지 (네트워크 오류 시)
  def image_url_with_fallback(attachment, fallback_color: '#3b82f6')
    url = image_url(attachment)

    # Fallback to placeholder if no image
    if url.blank?
      "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Crect fill='#{fallback_color}' width='100' height='100'/%3E%3C/svg%3E"
    else
      url
    end
  end
end
