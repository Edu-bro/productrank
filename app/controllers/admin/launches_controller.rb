class Admin::LaunchesController < Admin::BaseController
  before_action :set_launch, only: [:show, :edit, :update, :destroy]

  def index
    @launches = Launch.includes(:product).order(launch_date: :desc).page(params[:page]).per(20)

    # 상태 필터
    if params[:status].present?
      @launches = @launches.where(status: params[:status])
    end

    # 날짜 필터
    if params[:date_filter] == 'today'
      @launches = @launches.where('DATE(launch_date) = ?', Date.current)
    elsif params[:date_filter] == 'upcoming'
      @launches = @launches.where('launch_date > ?', Time.current)
    elsif params[:date_filter] == 'past'
      @launches = @launches.where('launch_date < ?', Time.current)
    end
  end

  def show
  end

  def new
    @launch = Launch.new
    @products = Product.all
  end

  def create
    @launch = Launch.new(launch_params)

    if @launch.save
      flash[:success] = "출시 일정이 등록되었습니다."
      redirect_to admin_launches_path
    else
      flash[:error] = "출시 일정 등록에 실패했습니다."
      @products = Product.all
      render :new
    end
  end

  def edit
    @products = Product.all
  end

  def update
    if @launch.update(launch_params)
      flash[:success] = "출시 일정이 업데이트되었습니다."
      redirect_to admin_launch_path(@launch)
    else
      flash[:error] = "업데이트에 실패했습니다."
      @products = Product.all
      render :edit
    end
  end

  def destroy
    @launch.destroy
    flash[:success] = "출시 일정이 삭제되었습니다."
    redirect_to admin_launches_path
  end

  private

  def set_launch
    @launch = Launch.find(params[:id])
  end

  def launch_params
    params.require(:launch).permit(:product_id, :launch_date, :region, :status, :description)
  end
end
