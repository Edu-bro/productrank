# OAuth 설정 - 카카오 로그인용
# 실제 토큰은 나중에 설정

OmniAuth.config.allowed_request_methods = %i[post get]
OmniAuth.config.silence_get_warning = true

Rails.application.config.middleware.use OmniAuth::Builder do
  # 카카오 OAuth2 설정 (임시)
  # provider :oauth2, 'kakao_client_id', 'kakao_client_secret',
  #   {
  #     name: 'kakao',
  #     client_options: {
  #       site: 'https://kapi.kakao.com',
  #       authorize_url: 'https://kauth.kakao.com/oauth/authorize',
  #       token_url: 'https://kauth.kakao.com/oauth/token'
  #     }
  #   }
end