class SessionsController < ApplicationController
  def new
    # 로그인 페이지
  end

  def kakao_login
    # 카카오 로그인 시뮬레이션 (임시)
    email = params[:email]
    
    if email == 'onesunjo@gmail.com'
      # 승인된 이메일로 로그인
      user = find_or_create_user_by_email(email, 'kakao_test')
      login_user(user)
      redirect_to root_path, notice: '카카오 로그인이 완료되었습니다!'
    else
      redirect_to login_path, alert: '승인되지 않은 계정입니다.'
    end
  end

  def google_login
    # 구글 로그인 시뮬레이션 (임시)
    email = params[:email]
    
    if email == 'onesunjo@gmail.com'
      # 승인된 이메일로 로그인
      user = find_or_create_user_by_email(email, 'google_test')
      login_user(user)
      redirect_to root_path, notice: '구글 로그인이 완료되었습니다!'
    else
      redirect_to login_path, alert: '승인되지 않은 계정입니다.'
    end
  end

  def omniauth_callback
    # 실제 OAuth 콜백 처리 (나중에 구현)
    auth = request.env['omniauth.auth']
    
    user = find_or_create_user_from_oauth(auth)
    if user.persisted?
      login_user(user)
      redirect_to root_path, notice: '로그인이 완료되었습니다!'
    else
      redirect_to login_path, alert: '로그인에 실패했습니다.'
    end
  end

  def destroy
    logout_user
    redirect_to root_path, notice: '로그아웃되었습니다.'
  end

  private

  def find_or_create_user_by_email(email, provider = 'kakao_test')
    user = User.find_by(email: email)

    unless user
      # 새 사용자 생성
      # Note: 실제 OAuth 구현 시 auth.info.image로 프로필 사진을 받아올 수 있습니다
      user = User.create!(
        name: email.split('@').first.capitalize,
        email: email,
        username: email.split('@').first,
        provider: provider,
        uid: "#{provider}_" + email.gsub('@', '_').gsub('.', '_'),
        avatar_url: nil # OAuth 연동 시 프로필 사진 URL 저장
      )
    end

    user
  end

  def find_or_create_user_from_oauth(auth)
    # OAuth 인증 정보로 사용자 찾기/생성
    User.find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.username = auth.info.nickname || auth.info.email.split('@').first
      user.avatar_url = auth.info.image
    end
  end

  def login_user(user)
    session[:user_id] = user.id
    session[:logged_in_at] = Time.current
  end

  def logout_user
    session[:user_id] = nil
    session[:logged_in_at] = nil
  end
end