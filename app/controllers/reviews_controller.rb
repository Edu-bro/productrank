class ReviewsController < ApplicationController
  protect_from_forgery except: [:create, :update, :destroy, :helpful]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_product, only: [:index, :create]
  before_action :set_review, only: [:show, :update, :destroy, :helpful]
  
  def index
    @reviews = @product.reviews.with_user.recent
    @reviews = @reviews.by_rating(params[:rating]) if params[:rating].present?
    @reviews = @reviews.page(params[:page]).per(10)
    
    @average_rating = @product.average_rating
    @review_count = @product.review_count
    @rating_distribution = @product.rating_distribution
    
    render json: {
      reviews: @reviews.map { |review| review_json(review) },
      average_rating: @average_rating,
      review_count: @review_count,
      rating_distribution: @rating_distribution,
      current_page: @reviews.current_page,
      total_pages: @reviews.total_pages
    }
  end
  
  def show
    render json: { review: review_json(@review) }
  end
  
  def create
    @review = @product.reviews.build(review_params)
    @review.user = current_user
    
    if @review.save
      render json: { 
        review: review_json(@review),
        message: '리뷰가 성공적으로 작성되었습니다.'
      }, status: :created
    else
      render json: { 
        errors: @review.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end
  
  def update
    if @review.user == current_user && @review.update(review_params)
      render json: { 
        review: review_json(@review),
        message: '리뷰가 성공적으로 수정되었습니다.'
      }
    else
      render json: { 
        errors: @review.errors.full_messages.presence || ['수정 권한이 없습니다.']
      }, status: :unprocessable_entity
    end
  end
  
  def destroy
    if @review.user == current_user || current_user.admin?
      @review.destroy
      render json: { message: '리뷰가 삭제되었습니다.' }
    else
      render json: { error: '삭제 권한이 없습니다.' }, status: :forbidden
    end
  end
  
  def helpful
    # 도움이 되었나요? 기능 (나중에 구현)
    @review.increment!(:helpful_count)
    render json: { 
      helpful_count: @review.helpful_count,
      message: '도움이 되었다고 표시했습니다.'
    }
  end
  
  private
  
  def set_product
    @product = Product.find(params[:product_id])
  end
  
  def set_review
    @review = Review.find(params[:id])
  end
  
  def review_params
    params.require(:review).permit(:rating, :content)
  end
  
  def review_json(review)
    {
      id: review.id,
      rating: review.rating,
      content: review.content,
      helpful_count: review.helpful_count,
      reply_count: review.reply_count,
      created_at: review.created_at.strftime('%Y년 %m월 %d일'),
      user: {
        id: review.user.id,
        name: review.user.name,
        avatar_url: user_avatar_url(review.user, size: 40)
      }
    }
  end
  
  def authenticate_user!
    # 임시로 샘플 사용자 생성 (실제로는 로그인 시스템 필요)
    # 현재는 항상 통과시켜서 테스트 가능하도록 함
    current_user
  end
  
  def current_user
    # 임시로 첫 번째 사용자 반환 (실제로는 세션/토큰 기반)
    @current_user ||= User.first || create_sample_user
  end
  
  def create_sample_user
    User.find_or_create_by(email: "test@example.com") do |user|
      user.name = "테스트 사용자"
      user.username = "testuser"
    end
  end
end