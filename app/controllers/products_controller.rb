class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :vote, :unvote]
  before_action :require_login, only: [:new, :create, :edit, :update, :vote, :unvote]
  
  def index
    @current_category = params[:category].present? ? params[:category] : 'all'
    @sort_by = params[:sort] || 'newest'
    
    # PERFORMANCE: Disabled caching temporarily for debugging
    # cache_key = "products_index_#{@current_category}_#{@sort_by}_#{params[:page] || 1}"
    
    # 카테고리 정보 (실제 Topics 테이블에서 동적으로 가져오기)
    @categories = [
      { slug: 'all', name: '전체', icon: '<i class="fas fa-th"></i>', color: '#667eea' }
    ]
    
    # 실제 토픽에서 카테고리 정보 추가
    icon_mapping = {
      'ai' => '<i class="fas fa-robot"></i>',
      'productivity' => '<i class="fas fa-rocket"></i>',
      'design' => '<i class="fas fa-palette"></i>',
      'development' => '<i class="fas fa-laptop-code"></i>',
      'health' => '<i class="fas fa-dumbbell"></i>',
      'finance' => '<i class="fas fa-dollar-sign"></i>',
      'education' => '<i class="fas fa-graduation-cap"></i>',
      'ecommerce' => '<i class="fas fa-shopping-cart"></i>'
    }
    
    color_mapping = {
      'ai' => '#8b5cf6',
      'productivity' => '#3b82f6',
      'design' => '#f59e0b',
      'development' => '#10b981',
      'health' => '#14b8a6',
      'finance' => '#ef4444',
      'education' => '#6366f1',
      'ecommerce' => '#dc2626'
    }
    
    Topic.all.each do |topic|
      @categories << {
        slug: topic.slug,
        name: topic.name,
        icon: icon_mapping[topic.slug] || '<i class="fas fa-tag"></i>',
        color: color_mapping[topic.slug] || '#6b7280'
      }
    end
    
    # 현재 카테고리 정보
    @current_category_info = @categories.find { |cat| cat[:slug] == @current_category }
    
    # 카테고리별 제품 데이터 구조 생성 (최적화된 단일 쿼리 사용)
    @categories_with_products = []
    
    if @current_category == 'all'
      # 전체 페이지일 때는 단일 쿼리로 모든 카테고리의 top 4 제품 조회
      @categories_with_products = fetch_all_categories_top_products
    else
      # 특정 카테고리 선택시: 해당 토픽의 공개된 제품들 (최적화)
      topic = Topic.find_by(slug: @current_category)
      if topic
        # OPTIMIZED: Minimal includes and select only needed fields
        products = get_sorted_products(
          Product.joins(:product_topics)
                 .includes(:user)  # Only essential relations
                 .select(:id, :name, :tagline, :description, :status, :created_at,
                         :votes_count, :likes_count, :comments_count, :user_id,
                         :updated_at, :key_features)  # Only needed fields
                 .where(status: [:live, :archived])
                 .where(product_topics: { topic_id: topic.id })
        ).page(params[:page]).per(20)
        
        @categories_with_products << {
          slug: @current_category,
          name: @current_category_info[:name],
          icon: @current_category_info[:icon],
          color: @current_category_info[:color],
          products: products
        }
        @paginated_products = products
      end
    end
    
    # 기존 @products 변수도 유지 (호환성을 위해)
    @products = @categories_with_products.flat_map { |cat| cat[:products] }
    
    # PERFORMANCE: Simplified topics preloading
    product_ids = @products.map(&:id)
    if product_ids.any?
      # Single query to get all needed topic relationships
      topic_data = ProductTopic.joins(:topic)
                              .where(product_id: product_ids)
                              .pluck(:product_id, 'topics.slug')
      
      @product_topics_map = topic_data.group_by(&:first)
                                     .transform_values { |pairs| pairs.map(&:last) }
    else
      @product_topics_map = {}
    end
    
    # PERFORMANCE: Caching disabled temporarily
    # Rails.cache.write(cache_key, {...}, expires_in: 15.minutes)
  end
  
  def show
    # 댓글 데이터 조회
    @comments = @product.comments.includes(:user, replies: :user).order(:created_at)
    @top_comments = @comments.where('upvotes > ?', 0).order(upvotes: :desc).limit(3)
    @recent_comments = @comments.order(created_at: :desc).limit(10)
    
    # 리뷰 데이터 처리
    @reviews = @product.reviews.includes(:user, replies: :user).order(created_at: :desc).limit(10)
    @average_rating = @product.average_rating
    @review_count = @product.review_count
    @rating_distribution = @product.rating_distribution
    
    # 갤러리 이미지 처리 (환경별 올바른 URL 생성)
    @gallery_images = build_gallery_images(@product)

    # 이미지가 없으면 기본 placeholder
    @gallery_images = ["https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=400&h=300&fit=crop"] if @gallery_images.empty?
    
    # 실제 메이커 팀원 정보
    @team_members = @product.maker_roles.includes(:user).map do |maker_role|
      user = maker_role.user
      {
        user: user,
        name: user.name,
        role: maker_role.role&.titleize || "메이커"
      }
    end
    
    # 유사 서비스 추천 (같은 토픽의 다른 제품들)
    @similar_products = Product.joins(:topics)
                              .where(topics: { id: @product.topic_ids })
                              .where.not(id: @product.id)
                              .includes(:topics, :votes, :likes)
                              .limit(3)
  end

  def new
    @product = Product.new
    @topics = Topic.all
  end

  def create
    @product = current_user.products.build(product_params)
    
    # URL 자동 보정 (http:// 추가)
    if @product.website_url.present? && !@product.website_url.match?(/\Ahttps?:\/\//)
      @product.website_url = "https://#{@product.website_url}"
    end
    
    # 주요 기능 처리
    if params[:key_features].present?
      features = params[:key_features].reject(&:blank?)
      @product.key_features_list = features
    end
    
    # 기본 상태는 즉시 공개
    @product.status = :live
    
    if @product.save
      # 토픽 연결
      if params[:topic_ids].present?
        @product.topics = Topic.where(id: params[:topic_ids])
      end
      
      # 팀원 정보 처리
      if params[:team_members].present?
        params[:team_members].each do |user_id, member_data|
          if member_data[:user_id].present?
            # position과 role을 합쳐서 role 필드에 저장
            role_text = if member_data[:position].present? && member_data[:role].present?
              "#{member_data[:position]} - #{member_data[:role]}"
            elsif member_data[:position].present?
              member_data[:position]
            elsif member_data[:role].present?
              member_data[:role]
            else
              "Creator"
            end

            @product.maker_roles.create(
              user_id: member_data[:user_id],
              role: role_text
            )
          end
        end
      end
      
      # 메이커 역할 추가 (등록자)
      @product.maker_roles.create(user: current_user, role: 'founder') unless @product.maker_roles.exists?(user: current_user)

      redirect_to @product, notice: '제품이 성공적으로 등록되어 즉시 공개되었습니다!'
    else
      @topics = Topic.all
      render :new
    end
  end

  def edit
    unless view_context.can_edit_product?(@product)
      redirect_to @product, alert: '제품을 편집할 권한이 없습니다.'
      return
    end
    @topics = Topic.all
  end

  def update
    unless view_context.can_edit_product?(@product)
      redirect_to @product, alert: '제품을 편집할 권한이 없습니다.'
      return
    end
    
    if @product.update(product_params)
      # 토픽 업데이트
      if params[:topic_ids].present?
        @product.topics = Topic.where(id: params[:topic_ids])
      end
      
      redirect_to @product, notice: '제품이 성공적으로 업데이트되었습니다!'
    else
      @topics = Topic.all
      render :edit
    end
  end

  def vote
    # 최적화: exists? 사용으로 속도 향상
    has_voted = @product.votes.exists?(user_id: current_user.id)

    respond_to do |format|
      if has_voted
        format.html { redirect_to @product, alert: '이미 투표하셨습니다.' }
        format.json { render json: { error: '이미 투표하셨습니다.' }, status: :unprocessable_entity }
      else
        # 최적화: create!로 변경하고 counter_cache 자동 업데이트 활용
        Vote.create!(user: current_user, product: @product, weight: 1)

        # 최적화: reload 없이 counter cache 값 직접 읽기
        new_count = @product.votes_count + 1

        format.html { redirect_to @product, notice: '투표해주셔서 감사합니다!' }
        format.json { render json: { votes_count: new_count, voted: true }, status: :ok }
      end
    end
  end

  def unvote
    vote = @product.votes.find_by(user: current_user)

    respond_to do |format|
      if vote
        vote.destroy
        new_count = @product.votes_count - 1

        format.html { redirect_to @product, notice: '투표가 취소되었습니다.' }
        format.json { render json: { votes_count: new_count, voted: false }, status: :ok }
      else
        format.html { redirect_to @product, alert: '투표 기록을 찾을 수 없습니다.' }
        format.json { render json: { error: '투표 기록을 찾을 수 없습니다.' }, status: :not_found }
      end
    end
  end
  
  private

  def build_gallery_images(product)
    images = []
    url_helper = Rails.application.routes.url_helpers
    # Production: 절대 URL (R2), Development: 상대 URL (로컬)
    use_only_path = Rails.env.development?

    # 1. 커버 이미지를 첫 번째로 추가 (목록 페이지와 일관성)
    if product.cover_image
      images << url_helper.rails_blob_path(product.cover_image, only_path: use_only_path)
    end

    # 2. 나머지 갤러리 이미지들 추가 (중복 제거)
    if product.product_images.attached?
      product.product_images.each do |image|
        url = url_helper.rails_blob_path(image, only_path: use_only_path)
        images << url unless images.include?(url)
      end
    end

    images
  end

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: '제품을 찾을 수 없습니다.'
  end

  def product_params
    params.require(:product).permit(:name, :tagline, :description, :website_url, :pricing_info, :featured, :key_features, :logo_image, :company_name, :company_description, :founded_year, :headquarters, :employee_count, :facebook_url, :instagram_url, :tiktok_url, :github_url, product_images: [])
  end

  
  # ULTRA OPTIMIZED: Single query approach for maximum performance
  def fetch_all_categories_top_products
    categories_with_products = []
    topic_slugs = @categories.reject { |cat| cat[:slug] == 'all' }.map { |cat| cat[:slug] }
    
    # Return only existing categories with actual products
    existing_topics = Topic.where(slug: topic_slugs)
    
    existing_topics.each do |topic|
      category_info = @categories.find { |cat| cat[:slug] == topic.slug }
      next unless category_info
      
      # Optimized query
      products = Product.joins(:product_topics)
                       .select('products.id, products.name, products.tagline, products.description,
                               products.votes_count, products.likes_count, products.comments_count,
                               products.user_id, products.updated_at, products.key_features')
                       .where(status: [:live, :archived])
                       .where(product_topics: { topic_id: topic.id })
                       .order(Arel.sql('(products.votes_count + products.likes_count * 2) DESC'))
                       .limit(4)
      
      if products.any?
        categories_with_products << {
          slug: topic.slug,
          name: category_info[:name],
          icon: category_info[:icon],
          color: category_info[:color],
          products: products
        }
      end
    end
    
    categories_with_products
  end

  def get_sorted_products(products)
    # Updated to use counter cache columns instead of expensive JOINs
    case @sort_by
    when 'newest'
      products.recent
    when 'likes'
      products.order(likes_count: :desc)
    when 'comments'
      products.order(comments_count: :desc)
    when 'votes'
      products.order(votes_count: :desc)
    else # popular (combination of votes and likes)
      products.order(Arel.sql('(votes_count + likes_count * 2) DESC'))
    end
  end
end