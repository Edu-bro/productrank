class RepliesController < ApplicationController
  protect_from_forgery except: [:create, :update, :destroy]
  before_action :authenticate_user!, except: [:index]
  before_action :set_review, only: [:index, :create]
  before_action :set_reply, only: [:update, :destroy]
  
  def index
    @replies = @review.replies.with_user.recent
    render json: {
      replies: @replies.map { |reply| reply_json(reply) }
    }
  end
  
  def create
    @reply = @review.replies.build(reply_params)
    @reply.user = current_user
    
    if @reply.save
      render json: { 
        reply: reply_json(@reply),
        message: '답글이 성공적으로 작성되었습니다.'
      }, status: :created
    else
      render json: { 
        errors: @reply.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end
  
  def update
    if @reply.user == current_user && @reply.update(reply_params)
      render json: { 
        reply: reply_json(@reply),
        message: '답글이 성공적으로 수정되었습니다.'
      }
    else
      render json: { 
        errors: @reply.errors.full_messages.presence || ['수정 권한이 없습니다.']
      }, status: :unprocessable_entity
    end
  end
  
  def destroy
    if @reply.user == current_user || current_user.admin?
      @reply.destroy
      render json: { message: '답글이 삭제되었습니다.' }
    else
      render json: { error: '삭제 권한이 없습니다.' }, status: :forbidden
    end
  end
  
  private
  
  def set_review
    @review = Review.find(params[:review_id])
  end
  
  def set_reply
    @reply = Reply.find(params[:id])
  end
  
  def reply_params
    params.require(:reply).permit(:content)
  end
  
  def reply_json(reply)
    {
      id: reply.id,
      content: reply.content,
      created_at: reply.created_at.strftime('%Y년 %m월 %d일'),
      user: {
        id: reply.user.id,
        name: reply.user.name,
        avatar_url: user_avatar_url(reply.user, size: 40)
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