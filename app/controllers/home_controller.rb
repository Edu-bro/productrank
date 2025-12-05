class HomeController < ApplicationController
  def index
    # 최적화된 includes로 N+1 쿼리 방지
    optimized_includes = [:makers, :topics, :user,
                         logo_image_attachment: :blob,
                         cover_image_attachment: :blob]

    # 오늘 신규 프로젝트 3개 (created_at 기준)
    @today_new_products = Product.published
                                .includes(optimized_includes)
                                .where('DATE(products.created_at) = ?', Date.current)
                                .order('products.created_at DESC')
                                .limit(3)

    # 어제 리더보드 상위 3개 (created_at 기준)
    @yesterday_top_products = Product.published
                                .includes(optimized_includes)
                                .where('DATE(products.created_at) = ?', Date.current - 1.day)
                                .order('products.votes_count DESC, products.likes_count DESC')
                                .limit(3)

    # 저번주 랭크보드 상위 3개 (created_at 기준 - 지난 7일)
    @last_week_top_products = Product.published
                                .includes(optimized_includes)
                                .where('DATE(products.created_at) >= ? AND DATE(products.created_at) < ?',
                                       Date.current - 7.days, Date.current)
                                .order('products.votes_count DESC, products.likes_count DESC')
                                .limit(3)

    # 저번달 랭크보드 상위 3개 (created_at 기준 - 지난 30일)
    @last_month_top_products = Product.published
                                .includes(optimized_includes)
                                .where('DATE(products.created_at) >= ? AND DATE(products.created_at) < ?',
                                       Date.current - 30.days, Date.current)
                                .order('products.votes_count DESC, products.likes_count DESC')
                                .limit(3)

    # 사이드바 데이터
    @popular_topics = Topic.joins(:product_topics).group('topics.id')
                           .order('COUNT(product_topics.id) DESC')
                           .limit(8)

    # upcoming_products 제거 (launches 테이블 삭제됨)
    @upcoming_products = []
  end
end
