class CommentsController < ApplicationController
  before_action :require_login
  before_action :find_product
  before_action :find_comment, only: [:edit, :update, :destroy]
  
  def create
    @comment = @product.comments.build(comment_params)
    @comment.user = current_user
    
    if @comment.save
      redirect_to @product, notice: '댓글이 성공적으로 등록되었습니다.'
    else
      redirect_to @product, alert: '댓글 등록에 실패했습니다.'
    end
  end
  
  def edit
    unless can_edit_comment?(@comment)
      redirect_to @product, alert: '댓글을 편집할 권한이 없습니다.'
    end
  end
  
  def update
    unless can_edit_comment?(@comment)
      redirect_to @product, alert: '댓글을 편집할 권한이 없습니다.'
      return
    end
    
    if @comment.update(comment_params)
      redirect_to @product, notice: '댓글이 성공적으로 수정되었습니다.'
    else
      render :edit
    end
  end
  
  def destroy
    unless can_edit_comment?(@comment)
      redirect_to @product, alert: '댓글을 삭제할 권한이 없습니다.'
      return
    end
    
    @comment.destroy
    redirect_to @product, notice: '댓글이 삭제되었습니다.'
  end
  
  private
  
  def find_product
    @product = Product.find(params[:product_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: '제품을 찾을 수 없습니다.'
  end
  
  def find_comment
    @comment = @product.comments.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to @product, alert: '댓글을 찾을 수 없습니다.'
  end
  
  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
  
  def can_edit_comment?(comment)
    return false unless current_user
    return true if current_user.admin?
    comment.user == current_user
  end
end
