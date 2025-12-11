namespace :storage do
  desc "Migrate Active Storage files from local disk to Cloudflare R2"
  task migrate_to_r2: :environment do
    puts "="*80
    puts "Starting migration of Active Storage files to Cloudflare R2"
    puts "="*80
    puts ""

    # Set up R2 configuration
    r2_config = {
      access_key_id: ENV['R2_ACCESS_KEY_ID'],
      secret_access_key: ENV['R2_SECRET_ACCESS_KEY'],
      region: 'auto',
      endpoint: ENV['R2_ENDPOINT'],
      force_path_style: true
    }

    # Validate R2 configuration
    if r2_config.values.any?(&:blank?)
      puts "❌ ERROR: R2 environment variables not set!"
      puts "Please set: R2_ACCESS_KEY_ID, R2_SECRET_ACCESS_KEY, R2_ENDPOINT"
      exit 1
    end

    bucket_name = ENV['R2_BUCKET']
    if bucket_name.blank?
      puts "❌ ERROR: R2_BUCKET environment variable not set!"
      exit 1
    end

    # Initialize S3 client for R2
    require 'aws-sdk-s3'
    s3_client = Aws::S3::Client.new(r2_config)

    puts "✅ Connected to Cloudflare R2"
    puts "   Bucket: #{bucket_name}"
    puts "   Endpoint: #{ENV['R2_ENDPOINT']}"
    puts ""

    # Get all active storage blobs
    total_blobs = ActiveStorage::Blob.count
    puts "Found #{total_blobs} total blobs in database"
    puts ""

    migrated_count = 0
    skipped_count = 0
    error_count = 0

    ActiveStorage::Blob.find_each.with_index do |blob, index|
      print "\rProcessing blob #{index + 1}/#{total_blobs}: #{blob.key}..."

      begin
        # Check if file exists in R2
        begin
          s3_client.head_object(bucket: bucket_name, key: blob.key)
          skipped_count += 1
          print " [SKIP - already exists]"
          next
        rescue Aws::S3::Errors::NotFound
          # File doesn't exist in R2, proceed with upload
        end

        # Get local file path
        local_service = ActiveStorage::Service::DiskService.new(root: Rails.root.join("storage"))
        local_path = local_service.path_for(blob.key)

        unless File.exist?(local_path)
          print " [SKIP - local file not found]"
          skipped_count += 1
          next
        end

        # Upload to R2
        File.open(local_path, 'rb') do |file|
          upload_params = {
            bucket: bucket_name,
            key: blob.key,
            body: file,
            content_type: blob.content_type || 'application/octet-stream',
            metadata: {
              'filename' => blob.filename.to_s,
              'byte_size' => blob.byte_size.to_s
            }
          }

          # Only add content_disposition if it exists
          if blob.respond_to?(:content_disposition) && blob.content_disposition.present?
            upload_params[:content_disposition] = blob.content_disposition
          end

          s3_client.put_object(upload_params)
        end

        migrated_count += 1
        print " [✓ MIGRATED]"

      rescue => e
        error_count += 1
        print " [✗ ERROR: #{e.message}]"
      end

      puts "" if (index + 1) % 10 == 0  # New line every 10 items for readability
    end

    puts "\n"
    puts "="*80
    puts "Migration completed!"
    puts "="*80
    puts "Total blobs:     #{total_blobs}"
    puts "Migrated:        #{migrated_count}"
    puts "Skipped:         #{skipped_count}"
    puts "Errors:          #{error_count}"
    puts ""

    if error_count > 0
      puts "⚠️  Some files failed to migrate. Check the logs above for details."
    else
      puts "✅ All files successfully migrated to Cloudflare R2!"
    end
    puts "="*80
  end

  desc "Verify R2 storage configuration and connectivity"
  task verify_r2: :environment do
    puts "Verifying Cloudflare R2 configuration..."
    puts ""

    # Check environment variables
    required_vars = ['R2_ACCESS_KEY_ID', 'R2_SECRET_ACCESS_KEY', 'R2_BUCKET', 'R2_ENDPOINT']
    missing_vars = required_vars.select { |var| ENV[var].blank? }

    if missing_vars.any?
      puts "❌ Missing environment variables: #{missing_vars.join(', ')}"
      exit 1
    end

    puts "✅ All environment variables are set"
    puts "   R2_BUCKET: #{ENV['R2_BUCKET']}"
    puts "   R2_ENDPOINT: #{ENV['R2_ENDPOINT']}"
    puts "   R2_ACCESS_KEY_ID: #{ENV['R2_ACCESS_KEY_ID'][0..7]}..."
    puts ""

    # Test R2 connection
    begin
      require 'aws-sdk-s3'

      s3_client = Aws::S3::Client.new(
        access_key_id: ENV['R2_ACCESS_KEY_ID'],
        secret_access_key: ENV['R2_SECRET_ACCESS_KEY'],
        region: 'auto',
        endpoint: ENV['R2_ENDPOINT'],
        force_path_style: true
      )

      # Try to list objects (just first one to verify connection)
      response = s3_client.list_objects_v2(bucket: ENV['R2_BUCKET'], max_keys: 1)

      puts "✅ Successfully connected to Cloudflare R2"
      puts "   Bucket '#{ENV['R2_BUCKET']}' is accessible"

      # Count objects in bucket
      all_objects = s3_client.list_objects_v2(bucket: ENV['R2_BUCKET'])
      object_count = all_objects.contents.size
      puts "   Current object count: #{object_count}"

    rescue => e
      puts "❌ Failed to connect to R2: #{e.message}"
      exit 1
    end

    puts ""
    puts "✅ R2 configuration is valid and working!"
  end
end
