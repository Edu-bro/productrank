class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :approve, :reject, :toggle_featured]

  def index
    @products = Product.includes(:user, :topics, :launches)
                      .order(created_at: :desc)
                      .page(params[:page]).per(20)

    # 필터링
    if params[:status].present?
      @products = @products.where(status: params[:status])
    end

    if params[:search].present?
      @products = @products.where('name LIKE ? OR description LIKE ?',
                                  "%#{params[:search]}%",
                                  "%#{params[:search]}%")
    end
  end

  def show
    @launch = @product.launches.first
    @comments = @product.comments.includes(:user).order(created_at: :desc).limit(10)
    @votes = @product.votes.includes(:user).order(created_at: :desc).limit(10)
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:success] = '제품이 성공적으로 수정되었습니다.'
      redirect_to admin_product_path(@product)
    else
      flash.now[:error] = '제품 수정에 실패했습니다.'
      render :edit
    end
  end

  def destroy
    @product.destroy
    flash[:success] = '제품이 삭제되었습니다.'
    redirect_to admin_products_path
  end

  # 제품 승인 (pending → live)
  def approve
    if @product.update(status: :live)
      flash[:success] = "#{@product.name}이(가) 승인되었습니다."
    else
      flash[:error] = '승인에 실패했습니다.'
    end
    redirect_to admin_products_path
  end

  # 제품 거부 (pending → draft)
  def reject
    if @product.update(status: :draft)
      flash[:success] = "#{@product.name}이(가) 거부되었습니다."
    else
      flash[:error] = '거부에 실패했습니다.'
    end
    redirect_to admin_products_path
  end

  # Featured 토글
  def toggle_featured
    @product.update(featured: !@product.featured)
    flash[:success] = "Featured 상태가 변경되었습니다."
    redirect_to admin_product_path(@product)
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name, :tagline, :description, :website_url,
      :logo_url, :cover_url, :status, :featured,
      :pricing_info, :key_features,
      topic_ids: []
    )
  end
end
