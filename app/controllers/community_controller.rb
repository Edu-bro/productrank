class CommunityController < ApplicationController
  def index
    @current_category = params[:category] || 'all'
    
    # 카테고리별 필터링
    case @current_category
    when 'discussion'
      @recent_posts = Product.includes(:makers, :topics, :votes, :comments)
                             .joins(:launches, :topics)
                             .where(launches: { status: :live })
                             .where(topics: { name: ['토론', '아이디어', '분석'] })
                             .order('created_at DESC')
                             .limit(10)
    when 'question'
      @recent_posts = Product.includes(:makers, :topics, :votes, :comments)
                             .joins(:launches, :topics)
                             .where(launches: { status: :live })
                             .where(topics: { name: ['질문', '도움', '문의'] })
                             .order('created_at DESC')
                             .limit(10)
    when 'feedback'
      @recent_posts = Product.includes(:makers, :topics, :votes, :comments)
                             .joins(:launches, :topics)
                             .where(launches: { status: :live })
                             .where(topics: { name: ['피드백', '개선요청', '버그'] })
                             .order('created_at DESC')
                             .limit(10)
    when 'review'
      @recent_posts = Product.includes(:makers, :topics, :votes, :comments)
                             .joins(:launches, :topics)
                             .where(launches: { status: :live })
                             .where(topics: { name: ['리뷰', '후기', '평가'] })
                             .order('created_at DESC')
                             .limit(10)
    when 'showcase'
      @recent_posts = Product.includes(:makers, :topics, :votes, :comments)
                             .joins(:launches, :topics)
                             .where(launches: { status: :live })
                             .where(topics: { name: ['쇼케이스', '프로젝트', '작품'] })
                             .order('created_at DESC')
                             .limit(10)
    when 'announcement'
      @recent_posts = Product.includes(:makers, :topics, :votes, :comments)
                             .joins(:launches, :topics)
                             .where(launches: { status: :live })
                             .where(topics: { name: ['공지', '업데이트', '뉴스'] })
                             .order('created_at DESC')
                             .limit(10)
    else
      # 전체
      @recent_posts = Product.includes(:makers, :topics, :votes, :comments)
                             .joins(:launches)
                             .where(launches: { status: :live })
                             .order('created_at DESC')
                             .limit(10)
    end
    
    # 사이드바 데이터
    @popular_topics = Topic.joins(:product_topics).group('topics.id')
                           .order('COUNT(product_topics.id) DESC')
                           .limit(8)
    
    @upcoming_products = Product.includes(:makers)
                                .joins(:launches)
                                .where(launches: { status: :scheduled })
                                .where('launches.launch_date > ?', Time.current)
                                .order('launches.launch_date ASC')
                                .limit(3)
  end
end
