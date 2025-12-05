class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # 인증 관련 헬퍼 메서드
  helper_method :current_user, :logged_in?, :can_edit_comment?

  # Avatar helper for controllers
  include ApplicationHelper
  
  protected
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
    nil
  end
  
  def logged_in?
    !!current_user
  end
  
  def require_login
    unless logged_in?
      redirect_to login_path, alert: '로그인이 필요합니다.'
    end
  end
  
  def require_admin
    unless logged_in? && current_user.admin?
      redirect_to root_path, alert: '관리자 권한이 필요합니다.'
    end
  end
  
  def can_edit_comment?(comment)
    return false unless current_user
    return true if current_user.admin?
    comment.user == current_user
  end
end
