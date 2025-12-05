class ChallengesController < ApplicationController
  def index
    # 기본적으로 주간 챌린지로 리다이렉트
    redirect_to challenges_weekly_path
  end

  def weekly
    @period_type = 'weekly'
    @challenge = Challenge.current_weekly
    @products = get_products
    @period_title = "이번 주 챌린지"

    render :show
  end

  def monthly
    @period_type = 'monthly'
    @challenge = Challenge.current_monthly
    @products = get_products
    @period_title = "이번 달 챌린지"

    render :show
  end

  private

  def get_products
    if @challenge
      products = @challenge.products
    else
      # 챌린지가 없으면 최근 일주일/한달 제품 표시
      time_range = @period_type == 'weekly' ? 1.week.ago : 1.month.ago
      products = Product.published.where('created_at >= ?', time_range)
    end

    # 카테고리 필터
    if params[:category].present? && params[:category] != '전체'
      products = products.joins(:product_topics).joins(:topics)
                        .where(topics: { slug: params[:category] })
    end

    # 정렬
    case params[:sort]
    when '최신순'
      products = products.order(created_at: :desc)
    when '댓글순'
      products = products.order(comments_count: :desc)
    else # 투표순 (기본값)
      products = products.order(votes_count: :desc, created_at: :desc)
    end

    products.limit(20)
  end
end
