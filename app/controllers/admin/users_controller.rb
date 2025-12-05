class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :toggle_role]

  def index
    @users = User.order(created_at: :desc).page(params[:page]).per(20)

    # 검색 기능
    if params[:search].present?
      @users = @users.where('name LIKE ? OR email LIKE ? OR username LIKE ?',
                            "%#{params[:search]}%",
                            "%#{params[:search]}%",
                            "%#{params[:search]}%")
    end

    # 역할 필터
    if params[:role].present?
      @users = @users.where(role: params[:role])
    end
  end

  def show
    @products = @user.products.order(created_at: :desc).limit(10)
    @votes = @user.votes.order(created_at: :desc).limit(10)
    @comments = @user.comments.order(created_at: :desc).limit(10)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "사용자 정보가 업데이트되었습니다."
      redirect_to admin_user_path(@user)
    else
      flash[:error] = "업데이트에 실패했습니다."
      render :edit
    end
  end

  def destroy
    if @user == current_user
      flash[:error] = "자신의 계정은 삭제할 수 없습니다."
      redirect_to admin_users_path
      return
    end

    @user.destroy
    flash[:success] = "사용자가 삭제되었습니다."
    redirect_to admin_users_path
  end

  def toggle_role
    if @user == current_user
      flash[:error] = "자신의 역할은 변경할 수 없습니다."
      redirect_to admin_user_path(@user)
      return
    end

    new_role = params[:new_role]
    if @user.update(role: new_role)
      flash[:success] = "#{@user.name}의 역할이 #{new_role}(으)로 변경되었습니다."
    else
      flash[:error] = "역할 변경에 실패했습니다."
    end

    redirect_to admin_user_path(@user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :username, :bio, :role)
  end
end
