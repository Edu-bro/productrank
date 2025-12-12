namespace :db do
  desc "Export image metadata (blobs and attachments) for production sync"
  task export_image_metadata: :environment do
    if Rails.env.production?
      puts "❌ This task should only run in development!"
      exit 1
    end

    puts "=== Exporting Image Metadata ==="
    puts ""

    require 'json'

    # Create export directory
    export_dir = "tmp/db_exports"
    system("mkdir -p #{export_dir}")

    timestamp = Time.current.strftime("%Y%m%d_%H%M%S")

    # Export Active Storage Blobs
    blobs_file = "#{export_dir}/active_storage_blobs_#{timestamp}.json"
    puts "📦 Exporting Active Storage Blobs..."

    blobs_data = ActiveStorage::Blob.all.map do |blob|
      {
        id: blob.id,
        key: blob.key,
        filename: blob.filename.to_s,
        content_type: blob.content_type,
        metadata: blob.metadata,
        service_name: blob.service_name,
        byte_size: blob.byte_size,
        checksum: blob.checksum,
        created_at: blob.created_at
      }
    end

    File.write(blobs_file, JSON.pretty_generate(blobs_data))
    puts "✅ Exported #{blobs_data.count} blobs → #{blobs_file}"

    # Export Active Storage Attachments
    attachments_file = "#{export_dir}/active_storage_attachments_#{timestamp}.json"
    puts "📎 Exporting Active Storage Attachments..."

    attachments_data = ActiveStorage::Attachment.all.map do |attachment|
      {
        id: attachment.id,
        name: attachment.name,
        record_type: attachment.record_type,
        record_id: attachment.record_id,
        blob_id: attachment.blob_id,
        created_at: attachment.created_at
      }
    end

    File.write(attachments_file, JSON.pretty_generate(attachments_data))
    puts "✅ Exported #{attachments_data.count} attachments → #{attachments_file}"

    # Generate import script for production
    script_file = "#{export_dir}/import_metadata_#{timestamp}.rb"
    puts "📝 Generating import script..."

    script_content = %Q{
require 'json'

puts "=== Importing Image Metadata to Production ==="
puts ""

if Rails.env.production?
  puts "⚠️  Running in production environment"
  puts "This will add image metadata records"
  puts ""
end

# Read and import blobs
blobs_file = ARGV[0] || Dir.glob("tmp/db_exports/active_storage_blobs_*.json").last
attachments_file = ARGV[1] || Dir.glob("tmp/db_exports/active_storage_attachments_*.json").last

unless blobs_file && File.exist?(blobs_file)
  puts "❌ Blobs file not found: #{blobs_file}"
  exit 1
end

unless attachments_file && File.exist?(attachments_file)
  puts "❌ Attachments file not found: #{attachments_file}"
  exit 1
end

# Import blobs
puts "Importing Active Storage Blobs..."
blobs_data = JSON.parse(File.read(blobs_file))

blobs_imported = 0
blobs_data.each do |blob_entry|
  begin
    # Check if blob already exists
    existing = ActiveStorage::Blob.find_by(key: blob_entry['key'])

    if existing
      puts "  ⚪ Blob #{blob_entry['id']} (\#{blob_entry['filename']}) already exists"
    else
      # Create new blob with specific ID
      blob = ActiveStorage::Blob.new(blob_entry.except('created_at'))
      blob.id = blob_entry['id']
      blob.created_at = blob_entry['created_at']
      blob.save!

      blobs_imported += 1
      puts "  ✅ Blob #{blob.id} (\#{blob.filename}) imported"
    end
  rescue => e
    puts "  ❌ Error importing blob \#{blob_entry['id']}: \#{e.message}"
  end
end

puts "Imported \#{blobs_imported} blobs"
puts ""

# Import attachments
puts "Importing Active Storage Attachments..."
attachments_data = JSON.parse(File.read(attachments_file))

attachments_imported = 0
attachments_data.each do |attachment_entry|
  begin
    # Check if attachment already exists
    existing = ActiveStorage::Attachment.find_by(
      record_type: attachment_entry['record_type'],
      record_id: attachment_entry['record_id'],
      name: attachment_entry['name']
    )

    if existing
      puts "  ⚪ Attachment \#{attachment_entry['id']} already exists"
    else
      # Create new attachment with specific ID
      attachment = ActiveStorage::Attachment.new(attachment_entry.except('created_at'))
      attachment.id = attachment_entry['id']
      attachment.created_at = attachment_entry['created_at']
      attachment.save!

      attachments_imported += 1
      puts "  ✅ Attachment \#{attachment.id} (\#{attachment.name} for \#{attachment.record_type}#\#{attachment.record_id}) imported"
    end
  rescue => e
    puts "  ❌ Error importing attachment \#{attachment_entry['id']}: \#{e.message}"
  end
end

puts "Imported \#{attachments_imported} attachments"
puts ""
puts "=== Import Complete ==="
puts "✅ All image metadata has been synced to production"
    }

    File.write(script_file, script_content)
    puts "✅ Generated import script → #{script_file}"

    puts ""
    puts "=== Export Complete ==="
    puts ""
    puts "📋 Files created:"
    puts "  1. #{blobs_file}"
    puts "  2. #{attachments_file}"
    puts "  3. #{script_file}"
    puts ""
    puts "Next steps:"
    puts "1. Upload these files to your Render project"
    puts "2. In Render Shell, run:"
    puts "   rails runner script/import_metadata_#{timestamp}.rb"
    puts ""
  end

  desc "Health check - verify DB connections and data"
  task health_check: :environment do
    puts "=== Database Health Check ==="
    puts ""
    puts "Environment: #{Rails.env}"
    puts "Database: #{Rails.configuration.database_configuration[Rails.env]['database']}"
    puts ""

    # Check connections
    begin
      result = ActiveRecord::Base.connection.select_value("SELECT 1")
      puts "✅ Database connection: OK"
    rescue => e
      puts "❌ Database connection: FAILED - #{e.message}"
      return
    end

    # Check table counts
    puts ""
    puts "Table Statistics:"
    puts "  Users: #{User.count}"
    puts "  Products: #{Product.count}"
    puts "  Topics: #{Topic.count}"
    puts "  Active Storage Blobs: #{ActiveStorage::Blob.count}"
    puts "  Active Storage Attachments: #{ActiveStorage::Attachment.count}"

    puts ""
    puts "Image Metadata by Product (first 10):"
    puts ""
    Product.limit(10).each do |product|
      puts "  Product ##{product.id} (#{product.name}):"
      if product.logo_image.attached?
        puts "    - Logo: #{product.logo_image.filename} (blob_id: #{product.logo_image.blob.id})"
      end
      if product.product_images.attached?
        puts "    - Images: #{product.product_images.count} files"
        product.product_images.each_with_index do |img, idx|
          puts "      #{idx + 1}. #{img.filename} (blob_id: #{img.blob.id})"
        end
      end
    end

    puts ""
    puts "✅ Database health check complete"
  end

  desc "Reset and seed database (development only)"
  task reset_dev: :environment do
    if Rails.env.production?
      puts "❌ Cannot reset production database!"
      exit 1
    end

    puts "Resetting development database..."
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke

    puts "✅ Development database reset and seeded"
  end
end
