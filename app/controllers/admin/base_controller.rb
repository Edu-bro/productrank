class Admin::BaseController < ApplicationController
  before_action :require_login
  before_action :require_admin

  layout 'admin'

  private

  def require_admin
    unless current_user&.admin?
      flash[:error] = '관리자 권한이 필요합니다.'
      redirect_to root_path
    end
  end
end
