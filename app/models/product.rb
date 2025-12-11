class Product < ApplicationRecord
  enum :status, { draft: 0, scheduled: 1, live: 2, archived: 3 }
  
  # Active Storage 첨부파일
  has_one_attached :logo_image
  has_many_attached :product_images  # 통합된 제품 이미지 (첫 번째가 커버)
  
  belongs_to :user
  has_many :maker_roles, dependent: :destroy
  has_many :makers, through: :maker_roles, source: :user
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_by_users, through: :likes, source: :user
  has_many :product_topics, dependent: :destroy
  has_many :topics, through: :product_topics
  has_many :collection_items, dependent: :destroy
  has_many :collections, through: :collection_items
  
  has_many :follows, as: :followable, dependent: :destroy
  has_many :followers, through: :follows, source: :follower
  
  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :tagline, presence: true, length: { maximum: 60 }
  validates :description, presence: true, length: { maximum: 500 }

  # 이미지 필수 검증
  validate :product_images_required
  validate :logo_image_required

  # 이미지 파일 크기 검증 (1MB)
  validate :logo_image_size_validation
  validate :product_images_size_validation

  # 회사 정보 (선택 사항)
  validates :company_name, length: { maximum: 100 }, allow_blank: true
  validates :founded_year, numericality: { only_integer: true, greater_than: 1800, less_than_or_equal_to: -> { Date.current.year } }, allow_nil: true
  validates :headquarters, length: { maximum: 200 }, allow_blank: true
  validates :employee_count, length: { maximum: 50 }, allow_blank: true
  validates :company_description, length: { maximum: 200 }, allow_blank: true

  private

  def product_images_required
    unless product_images.attached?
      errors.add(:product_images, '을(를) 최소 1개 이상 첨부해주세요')
    end
  end

  def logo_image_required
    unless logo_image.attached?
      errors.add(:logo_image, '을(를) 첨부해주세요')
    end
  end

  def logo_image_size_validation
    if logo_image.attached? && logo_image.blob.byte_size > 1.megabyte
      errors.add(:logo_image, '파일 크기는 1MB 이하여야 합니다')
    end
  end

  def product_images_size_validation
    return unless product_images.attached?

    product_images.each do |image|
      if image.blob.byte_size > 1.megabyte
        errors.add(:product_images, "중 일부 파일의 크기가 1MB를 초과합니다 (파일명: #{image.filename})")
      end
    end
  end

  public

  # Prewarm thumbnails after create/update - fixed callback method
  after_commit -> { ThumbPrewarmJob.perform_later(id) }, on: [:create, :update], if: -> { logo_image.attached? }

  scope :featured, -> { where(featured: true) }
  scope :by_status, ->(status) { where(status: status) }
  scope :recent, -> { order(created_at: :desc) }
  scope :published, -> { where(status: [:live, :archived]) }
  
  # Performance optimization: preload topics for cards
  scope :with_minimal_data, -> { includes(:user).select(:id, :name, :tagline, :description, :status, :created_at, :votes_count, :likes_count, :comments_count, :user_id, :cover_url, :logo_url) }
  
  # Cached user info to avoid N+1 queries
  def user_name
    @user_name ||= user&.name || 'Unknown User'
  end
  
  def vote_count
    # Use counter cache for performance - fallback to old method if cache not available
    votes_count || votes.sum(:weight)
  end
  
  def comment_count
    # Use counter cache for performance
    comments_count || comments.count
  end
  
  def likes_count  
    # Use counter cache for performance
    read_attribute(:likes_count) || likes.count
  end
  
  def review_count
    reviews.count
  end
  
  def average_rating
    return 0 if reviews.empty?
    (reviews.average(:rating) || 0).round(1)
  end
  
  def rating_distribution
    return {} if reviews.empty?
    reviews.group(:rating).count
  end
  
  
  # 주요 기능 관련 메서드
  def key_features_list
    return [] if key_features.blank?
    key_features.split(',').map(&:strip).reject(&:blank?)
  end
  
  def key_features_list=(features)
    self.key_features = features.reject(&:blank?).join(',')
  end

  # Image methods - simplified for performance (no variants)
  def logo_thumb_1x
    return nil unless logo_image.attached?

    url_helper = Rails.application.routes.url_helpers
    # Always use only_path: true - Rails will handle absolute URL generation
    # based on default_url_options configured in environment
    url_helper.rails_blob_path(logo_image, only_path: true)
  end

  def logo_thumb_2x
    logo_thumb_1x  # Use same as 1x for simplicity
  end

  # 커버 이미지는 첫 번째 제품 이미지
  def cover_image
    product_images.first if product_images.attached?
  end

  def cover_thumb_1x
    return nil unless cover_image

    url_helper = Rails.application.routes.url_helpers
    url_helper.rails_blob_path(cover_image, only_path: true)
  end

  def cover_thumb_2x
    cover_thumb_1x  # Use same as 1x for performance
  end

  def gallery_thumb_1x(image)
    return image unless image.is_a?(ActiveStorage::Blob) || image.respond_to?(:variant)

    url_helper = Rails.application.routes.url_helpers
    url_helper.rails_blob_path(image, only_path: true)
  end

  def gallery_thumb_2x(image)
    return image unless image.is_a?(ActiveStorage::Blob) || image.respond_to?(:variant)

    url_helper = Rails.application.routes.url_helpers
    url_helper.rails_representation_path(
      image.variant(resize_to_fill: [640, 400], quality: 70), only_path: true
    )
  end

  # Image URL methods (using only attached files)
  def logo_image_url
    return nil unless logo_image.attached?

    url_helper = Rails.application.routes.url_helpers
    url_helper.rails_blob_path(logo_image, only_path: true)
  end

  def cover_image_url
    return nil unless cover_image

    url_helper = Rails.application.routes.url_helpers
    url_helper.rails_blob_path(cover_image, only_path: true)
  end

  def gallery_image_urls
    return [] unless product_images.attached?

    url_helper = Rails.application.routes.url_helpers
    product_images.map { |image| url_helper.rails_blob_path(image, only_path: true) }
  end
  
  # 랭킹 및 트렌드 관련 메서드들 (간단한 버전)
  def daily_rank
    return nil unless created_at >= Date.current.beginning_of_day
    
    # 오늘 만들어진 제품들만 대상으로 간단한 랭킹
    better_products = Product.published
                            .where(created_at: Date.current.beginning_of_day..Date.current.end_of_day)
                            .where('(SELECT COUNT(*) FROM votes WHERE votes.product_id = products.id) > ?', vote_count)
                            .count
    
    better_products + 1
  end
  
  def weekly_rank
    return nil unless created_at >= 1.week.ago
    
    # 이번주 제품들 중에서 더 많은 투표를 받은 제품 수 + 1
    better_products = Product.published
                            .where(created_at: 1.week.ago..Time.current)
                            .where('(SELECT COUNT(*) FROM votes WHERE votes.product_id = products.id) > ?', vote_count)
                            .count
    
    better_products + 1
  end
  
  def monthly_rank
    return nil unless created_at >= 1.month.ago
    
    # 이번달 제품들 중에서 더 많은 투표를 받은 제품 수 + 1
    better_products = Product.published
                            .where(created_at: 1.month.ago..Time.current)
                            .where('(SELECT COUNT(*) FROM votes WHERE votes.product_id = products.id) > ?', vote_count)
                            .count
    
    better_products + 1
  end
  
  def is_trending?
    # 최근 24시간 내 투표가 전체 투표의 50% 이상인 경우
    recent_votes = votes.where(created_at: 24.hours.ago..Time.current).count
    total_votes = vote_count
    return false if total_votes < 5 # 최소 투표 수 요구
    recent_votes.to_f / total_votes > 0.5
  end
  
  def is_new?
    created_at > 7.days.ago
  end
  
  def launch_status_badge
    return "신규" if is_new?
    return "급상승" if is_trending?
    return "인기" if vote_count > 50
    return "론칭예정" if status == 'scheduled'
    nil
  end
  
  def best_rank_info
    ranks = [daily_rank, weekly_rank, monthly_rank].compact
    return nil if ranks.empty?

    best_rank = ranks.min
    period = case best_rank
             when daily_rank then "오늘"
             when weekly_rank then "이번주"
             when monthly_rank then "이번달"
             end

    { rank: best_rank, period: period }
  end

  # Check if a user has voted for this product
  def voted_by?(user)
    return false unless user
    votes.exists?(user_id: user.id)
  end

  # Check if a user has commented on this product
  def commented_by?(user)
    return false unless user
    comments.exists?(user_id: user.id)
  end

end
