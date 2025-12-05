class LikesController < ApplicationController
  before_action :require_login
  before_action :find_product
  
  def create
    existing_like = current_user.likes.find_by(product: @product)
    
    if existing_like
      # 이미 좋아요가 있으면 취소
      existing_like.destroy
      render json: { 
        liked: false, 
        likes_count: @product.reload.likes_count,
        message: '좋아요를 취소했습니다.'
      }
    else
      # 좋아요 추가
      @like = current_user.likes.build(product: @product)
      if @like.save
        render json: { 
          liked: true, 
          likes_count: @product.reload.likes_count,
          message: '좋아요를 추가했습니다.'
        }
      else
        render json: { 
          error: '좋아요 처리에 실패했습니다.',
          likes_count: @product.likes_count
        }, status: :unprocessable_entity
      end
    end
  end
  
  def destroy
    @like = current_user.likes.find_by(product: @product)
    
    if @like&.destroy
      render json: { 
        liked: false, 
        likes_count: @product.likes_count,
        message: '좋아요를 취소했습니다.'
      }
    else
      render json: { 
        error: '좋아요를 찾을 수 없습니다.',
        likes_count: @product.likes_count
      }, status: :not_found
    end
  end
  
  private
  
  def require_login
    unless logged_in?
      render json: { error: '로그인이 필요합니다.' }, status: :unauthorized
    end
  end
  
  def find_product
    @product = Product.find(params[:product_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: '제품을 찾을 수 없습니다.' }, status: :not_found
  end
end
