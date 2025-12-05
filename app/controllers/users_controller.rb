class UsersController < ApplicationController
  before_action :require_login, except: [:search]

  def search
    query = params[:q].to_s.strip

    if query.length < 2
      render json: []
      return
    end

    # Search users by name or email (case-insensitive)
    users = User.where("LOWER(name) LIKE ? OR LOWER(email) LIKE ?",
                       "%#{query.downcase}%",
                       "%#{query.downcase}%")
                .limit(10)
                .select(:id, :name, :email)

    render json: users.map { |u|
      {
        id: u.id,
        name: u.name,
        email: u.email
      }
    }
  end

  def show
    @user = current_user

    # 좋아요한 제품
    @liked_products = @user.liked_products.includes(:user, :topics).order('likes.created_at DESC')

    # 작성한 댓글
    @comments = @user.comments.includes(:product).order(created_at: :desc)

    # 작성한 리뷰
    @reviews = @user.reviews.includes(:product).order(created_at: :desc)

    # 등록한 제품
    @my_products = @user.products.includes(:topics).order(created_at: :desc)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    
    if @user.update(user_params)
      redirect_to my_path, notice: '프로필이 업데이트되었습니다.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def require_login
    unless logged_in?
      redirect_to login_path, alert: '로그인이 필요합니다.'
    end
  end
  
  def user_params
    params.require(:user).permit(:name, :username, :email, :avatar_url, :avatar, :bio, :job_title, :website, :github_url, :twitter_url, :linkedin_url)
  end
end
