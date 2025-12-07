class HomeController < ApplicationController
  def index
    # 최적화된 includes로 N+1 쿼리 방지
    optimized_includes = [:makers, :topics, :user,
                         logo_image_attachment: :blob,
                         product_images_attachments: :blob]

    # 이번주 신규 제품 5개 (이번 주 월요일부터 지금까지)
    week_start = Date.current.beginning_of_week
    @this_week_new_products = Product.published
                                .includes(optimized_includes)
                                .where('DATE(products.created_at) >= ?', week_start)
                                .order('products.created_at DESC')
                                .limit(5)

    # 이번달 신규 제품 5개 (이번 달 1일부터 지금까지)
    month_start = Date.current.beginning_of_month
    @this_month_new_products = Product.published
                                .includes(optimized_includes)
                                .where('DATE(products.created_at) >= ?', month_start)
                                .order('products.created_at DESC')
                                .limit(5)

    # 저번주 랭크보드 상위 5개 (지난주 월요일~일요일)
    last_week_start = (Date.current - 1.week).beginning_of_week
    last_week_end = (Date.current - 1.week).end_of_week
    @last_week_top_products = Product.published
                                .includes(optimized_includes)
                                .where('DATE(products.created_at) >= ? AND DATE(products.created_at) <= ?',
                                       last_week_start, last_week_end)
                                .order('products.votes_count DESC, products.likes_count DESC')
                                .limit(5)

    # 저번달 랭크보드 상위 5개 (지난달 1일~말일)
    last_month_start = (Date.current - 1.month).beginning_of_month
    last_month_end = (Date.current - 1.month).end_of_month
    @last_month_top_products = Product.published
                                .includes(optimized_includes)
                                .where('DATE(products.created_at) >= ? AND DATE(products.created_at) <= ?',
                                       last_month_start, last_month_end)
                                .order('products.votes_count DESC, products.likes_count DESC')
                                .limit(5)

    # 사이드바 데이터
    @popular_topics = Topic.joins(:product_topics).group('topics.id')
                           .order('COUNT(product_topics.id) DESC')
                           .limit(8)

    # 인기 제품 3개 (전체 기간 중 투표수 + 좋아요 수가 높은 제품)
    @popular_products = Product.published
                               .includes(optimized_includes)
                               .order('products.votes_count DESC, products.likes_count DESC')
                               .limit(3)
  end
end
