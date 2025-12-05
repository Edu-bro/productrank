class CollectionsController < ApplicationController
  before_action :require_login
  
  def index
    # 사용자의 좋아요를 최신순으로 가져와서 제품 정보와 함께 표시
    @user_likes = current_user.likes.includes(:product).order(created_at: :desc)
    @liked_products = @user_likes.map(&:product)
    
    # 빈 상태 메시지 설정
    @empty_message = "아직 좋아요한 제품이 없습니다" if @liked_products.empty?
  end
  
  private
  
  def require_login
    unless logged_in?
      redirect_to login_path, alert: '로그인이 필요합니다.'
    end
  end
end
