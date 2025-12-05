class Admin::TopicsController < Admin::BaseController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  def index
    @topics = Topic.order(name: :asc).page(params[:page]).per(20)

    # 검색 기능
    if params[:search].present?
      @topics = @topics.where('name LIKE ? OR description LIKE ?',
                              "%#{params[:search]}%",
                              "%#{params[:search]}%")
    end
  end

  def show
    @products = @topic.products.order(created_at: :desc).limit(20)
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)

    if @topic.save
      flash[:success] = "토픽이 생성되었습니다."
      redirect_to admin_topics_path
    else
      flash[:error] = "토픽 생성에 실패했습니다."
      render :new
    end
  end

  def edit
  end

  def update
    if @topic.update(topic_params)
      flash[:success] = "토픽이 업데이트되었습니다."
      redirect_to admin_topic_path(@topic)
    else
      flash[:error] = "업데이트에 실패했습니다."
      render :edit
    end
  end

  def destroy
    @topic.destroy
    flash[:success] = "토픽이 삭제되었습니다."
    redirect_to admin_topics_path
  end

  private

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:name, :slug, :description, :emoji)
  end
end
