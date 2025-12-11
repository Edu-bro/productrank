module ApplicationHelper
  def get_topic_emoji(topic_slug)
    # DB에서 토픽 이모지 가져오기 (캐싱 포함)
    topic = Topic.find_by(slug: topic_slug)
    topic&.emoji || '📦'
  end
  
  # PERFORMANCE: Get preloaded topic slugs for product to avoid N+1 queries
  def get_product_first_topic_slug(product)
    if defined?(@product_topics_map) && @product_topics_map
      topic_slugs = @product_topics_map[product.id]
      topic_slugs&.first || 'default'
    else
      product.topics.first&.slug || 'default'
    end
  end
  
  # Check if current user can edit the product
  def can_edit_product?(product)
    return false unless current_user
    return true if current_user.admin?

    # Check if user is a maker of the product
    product.maker_roles.exists?(user: current_user)
  end

  # Get user avatar URL with consistent fallback priority
  # Priority: 1. Active Storage avatar, 2. avatar_url field, 3. Placeholder
  def user_avatar_url(user, size: 40)
    return nil unless user

    if user.avatar.attached?
      url_helper = Rails.application.routes.url_helpers
      url_helper.rails_blob_path(user.avatar, only_path: true)
    elsif user.avatar_url.present?
      user.avatar_url
    else
      nil # Will be handled by caller with placeholder
    end
  end

  # Generate avatar placeholder (initial letter with gradient)
  def user_avatar_placeholder(user, size: 40)
    initial = user&.name&.first&.upcase || '?'
    content_tag :div, initial,
                class: 'avatar-placeholder',
                style: "width: #{size}px; height: #{size}px; border-radius: 50%; background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); color: white; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: #{size / 2.5}px;"
  end

  # Complete avatar tag with fallback
  def user_avatar_tag(user, size: 40, css_class: 'user-avatar')
    avatar_url = user_avatar_url(user, size: size)

    if avatar_url
      image_tag avatar_url, alt: user.name, class: css_class, style: "width: #{size}px; height: #{size}px; border-radius: 50%; object-fit: cover;"
    else
      user_avatar_placeholder(user, size: size)
    end
  end

  # Get product logo URL with consistent fallback priority
  # Priority: 1. Active Storage logo_image, 2. logo_url field, 3. nil (use placeholder)
  def product_logo_url(product)
    return nil unless product

    if product.logo_image.attached?
      url_helper = Rails.application.routes.url_helpers
      url_helper.rails_blob_path(product.logo_image, only_path: true)
    elsif product.logo_url.present?
      product.logo_url
    else
      nil
    end
  end

  # Generate product logo placeholder (initial letter with gradient)
  def product_logo_placeholder(product, size: 80, border_radius: '12px')
    initial = product&.name&.first&.upcase || '?'
    content_tag :div, initial,
                class: 'logo-placeholder',
                style: "width: #{size}px; height: #{size}px; border-radius: #{border_radius}; background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); color: white; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: #{size / 2}px;"
  end

  # Complete product logo tag with fallback
  def product_logo_tag(product, size: 80, css_class: 'product-logo', border_radius: '12px')
    logo_url = product_logo_url(product)

    if logo_url.present?
      image_tag logo_url, alt: "#{product.name} 로고", class: css_class, style: "width: #{size}px; height: #{size}px; border-radius: #{border_radius}; object-fit: cover;"
    else
      product_logo_placeholder(product, size: size, border_radius: border_radius)
    end
  end

  # Product cover/thumbnail for cards (full width/height version)
  def product_cover_tag(product, css_class: '', style: '')
    url_helper = Rails.application.routes.url_helpers

    if product.cover_image
      cover_url = url_helper.rails_blob_path(product.cover_image, only_path: true)
      image_tag cover_url, alt: product.name, class: css_class, style: "width: 100%; height: 100%; object-fit: cover; #{style}"
    elsif product.cover_url.present?
      image_tag product.cover_url, alt: product.name, class: css_class, style: "width: 100%; height: 100%; object-fit: cover; #{style}"
    elsif product.logo_image.attached?
      logo_url = url_helper.rails_blob_path(product.logo_image, only_path: true)
      image_tag logo_url, alt: product.name, class: css_class, style: "width: 100%; height: 100%; object-fit: cover; #{style}"
    elsif product.logo_url.present?
      image_tag product.logo_url, alt: product.name, class: css_class, style: "width: 100%; height: 100%; object-fit: cover; #{style}"
    else
      content_tag :div, product.name.first.upcase,
                  class: "#{css_class} logo-placeholder",
                  style: "width: 100%; height: 100%; background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%); color: white; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 2rem; #{style}"
    end
  end
end
