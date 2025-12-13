class Admin::DatabaseController < ApplicationController
  # Skip CSRF verification for API-like endpoints
  skip_before_action :verify_authenticity_token, only: [:import, :status]

  # Security: Only allow import with correct secret token
  before_action :verify_import_token, only: [:import]

  def import
    begin
      Rails.logger.info "🔄 Starting database import via web endpoint..."

      # Load and execute the import script
      require Rails.root.join('script/sync_complete_database.rb')
      sync = DatabaseSync.new

      result = sync.import_all

      Rails.logger.info "✅ Database import completed successfully"

      render json: {
        status: 'success',
        message: 'Database import completed successfully',
        timestamp: Time.current,
        details: result
      }, status: :ok

    rescue => e
      Rails.logger.error "❌ Database import failed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")

      render json: {
        status: 'error',
        message: e.message,
        backtrace: e.backtrace.first(10)
      }, status: :internal_server_error
    end
  end

  def status
    render json: {
      environment: Rails.env,
      database: ActiveRecord::Base.connection.adapter_name,
      counts: {
        users: User.count,
        topics: Topic.count,
        products: Product.count,
        product_topics: ProductTopic.count,
        active_storage_blobs: ActiveStorage::Blob.count,
        active_storage_attachments: ActiveStorage::Attachment.count
      },
      sample_product: Product.first&.as_json(only: [:id, :name, :tagline]),
      timestamp: Time.current
    }
  end

  private

  def verify_import_token
    # Use environment variable for security
    expected_token = ENV['DATABASE_IMPORT_TOKEN'] || 'import-secret-2024'
    provided_token = params[:token]

    unless provided_token == expected_token
      render json: {
        status: 'unauthorized',
        message: 'Invalid or missing import token'
      }, status: :unauthorized
    end
  end
end
