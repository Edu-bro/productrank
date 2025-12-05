# Active Storage configuration for better development performance
Rails.application.config.after_initialize do
  # Ensure consistent CORS handling for Active Storage
  if Rails.env.development?
    # Override default headers for Active Storage responses
    ActiveStorage::BaseController.class_eval do
      before_action :set_cors_headers
      
      private
      
      def set_cors_headers
        response.headers['Access-Control-Allow-Origin'] = '*'
        response.headers['Access-Control-Allow-Methods'] = 'GET, HEAD, OPTIONS'
        response.headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Cache-Control'
        response.headers['Access-Control-Max-Age'] = '86400'
      end
    end
  end
end