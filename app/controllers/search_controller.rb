class SearchController < ApplicationController
  def index
    @query = params[:q]&.strip
    @category = params[:category]
    @sort_by = params[:sort] || 'relevance'
    @search_type = params[:type] || 'all'
    @page = params[:page] || 1
    
    @results = []
    @users = []
    @comments = []
    @total_count = 0
    
    if @query.present?
      case @search_type
      when 'products'
        @results = search_products(@query, @category, @sort_by)
        @total_count = @results.count
      when 'users'
        @users = search_users(@query)
        @total_count = @users.count
      when 'community'
        @comments = search_comments(@query)
        @total_count = @comments.count
      else # 'all'
        @results = search_products(@query, @category, @sort_by)
        @users = search_users(@query).limit(5)
        @comments = search_comments(@query).limit(5)
        @leaderboards = get_relevant_leaderboards(@query)
        @total_count = @results.count + @users.count + @comments.count + @leaderboards.count
      end
      
      # 페이지네이션 (간단한 구현)
      if @search_type == 'products' || @search_type == 'all'
        @results = @results.limit(20).offset((@page.to_i - 1) * 20)
      end
    end
    
    @categories = [
      { slug: '', name: '전체 카테고리' },
      { slug: 'productivity', name: '생산성 도구' },
      { slug: 'engineering', name: '개발 도구' },
      { slug: 'design', name: '디자인 & 창작' },
      { slug: 'finance', name: '금융 서비스' },
      { slug: 'social', name: '소셜 & 커뮤니티' },
      { slug: 'marketing', name: '마케팅 & 세일즈' },
      { slug: 'health', name: '헬스 & 피트니스' },
      { slug: 'travel', name: '여행' },
      { slug: 'ai', name: 'AI & 머신러닝' },
      { slug: 'web3', name: 'Web3 & 블록체인' },
      { slug: 'ecommerce', name: '이커머스' }
    ]
    
    @topics = Topic.all
  end
  
  def suggestions
    query = params[:q]&.strip
    search_type = params[:type] || 'all'
    
    if query.present? && query.length >= 2
      suggestions = []
      
      case search_type
      when 'products', 'all'
        # 제품 이름 기반 자동완성 (SQLite 호환, 공개된 제품만)
        product_suggestions = Product.published
                                    .where("name LIKE ? COLLATE NOCASE", "%#{query}%")
                                    .limit(5)
                                    .pluck(:name)
        suggestions += product_suggestions
        
        # 토픽 기반 자동완성 (SQLite 호환)
        topic_suggestions = Topic.where("name LIKE ? COLLATE NOCASE", "%#{query}%")
                               .limit(3)
                               .pluck(:name)
        suggestions += topic_suggestions
      when 'users'
        # 사용자 이름 기반 자동완성
        user_suggestions = User.where("name LIKE ? COLLATE NOCASE OR username LIKE ? COLLATE NOCASE", 
                                     "%#{query}%", "%#{query}%")
                              .limit(8)
                              .pluck(:name, :username)
                              .flatten
        suggestions += user_suggestions
      when 'community'
        # 인기 있는 댓글 키워드 자동완성 (간단한 구현)
        comment_keywords = ['리뷰', '추천', '사용법', '비교', '장점', '단점', '가격', '기능']
        suggestions += comment_keywords.select { |keyword| keyword.include?(query) }
      end
      
      suggestions = suggestions.uniq.first(8)
      
      render json: { suggestions: suggestions }
    else
      render json: { suggestions: [] }
    end
  end
  
  private
  
  def search_products(query, category = nil, sort_by = 'relevance')
    # 기본 검색 스코프 (공개된 제품만)
    scope = Product.includes(:topics, :votes, :comments, :user).published
    
    # 텍스트 검색 (이름, 태그라인, 설명) - SQLite 호환
    if query.present?
      search_terms = query.split(/\s+/).map { |term| "%#{term}%" }
      
      search_condition = search_terms.map do |term|
        "(products.name LIKE ? COLLATE NOCASE OR products.tagline LIKE ? COLLATE NOCASE OR products.description LIKE ? COLLATE NOCASE)"
      end.join(" AND ")
      
      search_values = search_terms.flat_map { |term| [term, term, term] }
      
      scope = scope.where(search_condition, *search_values)
    end
    
    # 카테고리 필터
    if category.present?
      # 토픽을 통한 필터링
      topic_names = case category
      when 'productivity'
        ['생산성', 'productivity']
      when 'engineering' 
        ['개발', 'engineering', '프로그래밍']
      when 'design'
        ['디자인', 'design']
      when 'ai'
        ['인공지능', 'AI', 'artificial intelligence']
      when 'finance'
        ['금융', 'finance', '핀테크']
      when 'health'
        ['건강', 'health', '헬스케어']
      else
        [category]
      end
      
      scope = scope.joins(:topics).where(topics: { name: topic_names })
    end
    
    # 정렬
    case sort_by
    when 'newest'
      scope = scope.order(created_at: :desc)
    when 'popular'
      scope = scope.left_joins(:votes)
                  .group('products.id')
                  .order('COUNT(votes.id) DESC')
    when 'trending'
      # 최근 7일간 투표가 많은 순
      scope = scope.joins(:votes)
                  .where('votes.created_at > ?', 7.days.ago)
                  .group('products.id')
                  .order('COUNT(votes.id) DESC')
    when 'alphabetical'
      scope = scope.order(:name)
    else # relevance
      # 간단한 관련성 점수 (이름 매치 > 태그라인 매치 > 설명 매치) - SQLite 호환
      if query.present?
        escaped_query = query.gsub("'", "''")  # SQL 인젝션 방지
        scope = scope.order(
          Arel.sql("
            CASE 
              WHEN products.name LIKE '%#{escaped_query}%' COLLATE NOCASE THEN 3
              WHEN products.tagline LIKE '%#{escaped_query}%' COLLATE NOCASE THEN 2
              WHEN products.description LIKE '%#{escaped_query}%' COLLATE NOCASE THEN 1
              ELSE 0
            END DESC,
            products.created_at DESC
          ")
        )
      else
        scope = scope.order(created_at: :desc)
      end
    end
    
    scope.distinct
  end
  
  def search_users(query)
    User.where("name LIKE ? COLLATE NOCASE OR username LIKE ? COLLATE NOCASE OR bio LIKE ? COLLATE NOCASE", 
               "%#{query}%", "%#{query}%", "%#{query}%")
        .order(
          Arel.sql("
            CASE 
              WHEN users.name LIKE '%#{query.gsub("'", "''")}%' COLLATE NOCASE THEN 3
              WHEN users.username LIKE '%#{query.gsub("'", "''")}%' COLLATE NOCASE THEN 2
              WHEN users.bio LIKE '%#{query.gsub("'", "''")}%' COLLATE NOCASE THEN 1
              ELSE 0
            END DESC,
            users.reputation DESC
          ")
        )
  end
  
  def search_comments(query)
    Comment.includes(:user, :product)
           .where("body LIKE ? COLLATE NOCASE", "%#{query}%")
           .order(created_at: :desc)
  end
  
  def get_relevant_leaderboards(query)
    leaderboards = []
    
    # 오늘의 랭크보드 (관련 키워드가 포함된 제품들)
    today_products = Product.published
                           .where("name LIKE ? COLLATE NOCASE OR tagline LIKE ? COLLATE NOCASE OR description LIKE ? COLLATE NOCASE", 
                                  "%#{query}%", "%#{query}%", "%#{query}%")
                           .where(created_at: Date.current.beginning_of_day..Date.current.end_of_day)
                           .order(Arel.sql('(SELECT COUNT(*) FROM votes WHERE votes.product_id = products.id) DESC'))
                           .limit(5)
    
    if today_products.any?
      leaderboards << {
        title: "오늘의 '#{query}' 관련 제품 랭킹",
        period: :daily,
        products: today_products.map.with_index(1) { |product, index| { product: product, rank: index } }
      }
    end
    
    # 이번주 랭크보드
    week_products = Product.published
                          .where("name LIKE ? COLLATE NOCASE OR tagline LIKE ? COLLATE NOCASE OR description LIKE ? COLLATE NOCASE", 
                                 "%#{query}%", "%#{query}%", "%#{query}%")
                          .where(created_at: 1.week.ago..Time.current)
                          .order(Arel.sql('(SELECT COUNT(*) FROM votes WHERE votes.product_id = products.id) DESC'))
                          .limit(5)
    
    if week_products.any?
      leaderboards << {
        title: "이번주 '#{query}' 관련 제품 랭킹",
        period: :weekly,
        products: week_products.map.with_index(1) { |product, index| { product: product, rank: index } }
      }
    end
    
    # 카테고리별 랭킹 (토픽 기반)
    if @category.present?
      category_products = Product.published
                                .joins(:topics)
                                .where(topics: { name: get_topic_names_for_category(@category) })
                                .order(Arel.sql('(SELECT COUNT(*) FROM votes WHERE votes.product_id = products.id) DESC'))
                                .limit(5)
      
      if category_products.any?
        category_name = @categories.find { |cat| cat[:slug] == @category }&.dig(:name) || @category
        leaderboards << {
          title: "#{category_name} 카테고리 랭킹",
          period: :category,
          products: category_products.map.with_index(1) { |product, index| { product: product, rank: index } }
        }
      end
    end
    
    leaderboards
  end
  
  def get_topic_names_for_category(category)
    case category
    when 'productivity'
      ['생산성', 'productivity']
    when 'engineering' 
      ['개발', 'engineering', '프로그래밍']
    when 'design'
      ['디자인', 'design']
    when 'ai'
      ['인공지능', 'AI', 'artificial intelligence']
    when 'finance'
      ['금융', 'finance', '핀테크']
    when 'health'
      ['건강', 'health', '헬스케어']
    else
      [category]
    end
  end
end
