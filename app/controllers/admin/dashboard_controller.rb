class Admin::DashboardController < Admin::BaseController
  def index
    # 통계 데이터
    @stats = {
      products: {
        total: Product.count,
        live: Product.where(status: :live).count,
        scheduled: Product.where(status: :scheduled).count,
        pending: Product.where(status: :pending).count
      },
      users: {
        total: User.count,
        admins: User.where(role: :admin).count,
        makers: User.where(role: :maker).count
      },
      launches: {
        today: Launch.where('DATE(launch_date) = ?', Date.current).count,
        this_week: Launch.where('DATE(launch_date) >= ? AND DATE(launch_date) <= ?',
                                Date.current.beginning_of_week, Date.current.end_of_week).count,
        upcoming: Launch.where('DATE(launch_date) > ?', Date.current).count
      },
      interactions: {
        votes: Vote.count,
        likes: Like.count,
        comments: Comment.count,
        reviews: Review.count
      }
    }

    # 최근 제품 (최근 10개)
    @recent_products = Product.order(created_at: :desc).limit(10)

    # 인기 제품 TOP 10
    @top_products = Product.where(status: :live)
                           .order(votes_count: :desc, likes_count: :desc)
                           .limit(10)

    # 최근 가입 사용자
    @recent_users = User.order(created_at: :desc).limit(10)
  end
end
