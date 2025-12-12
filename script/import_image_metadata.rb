#!/usr/bin/env rails runner
# Script to import image metadata (blobs and attachments) to production
# Usage: rails runner script/import_image_metadata.rb
# Or on Render shell: rails runner script/import_image_metadata.rb

require 'json'

puts "=== Importing Image Metadata to Production ==="
puts ""

if Rails.env.production?
  puts "⚠️  Running in production environment"
  puts "This will add image metadata records"
  puts ""
end

# Find the latest exported files
blobs_file = Dir.glob("tmp/db_exports/active_storage_blobs_*.json").max
attachments_file = Dir.glob("tmp/db_exports/active_storage_attachments_*.json").max

unless blobs_file && File.exist?(blobs_file)
  puts "❌ Blobs file not found in tmp/db_exports/"
  puts "Please run: RAILS_ENV=development bundle exec rails db:export_image_metadata"
  exit 1
end

unless attachments_file && File.exist?(attachments_file)
  puts "❌ Attachments file not found in tmp/db_exports/"
  exit 1
end

puts "📄 Using files:"
puts "  - #{File.basename(blobs_file)}"
puts "  - #{File.basename(attachments_file)}"
puts ""

# Import blobs
puts "Importing Active Storage Blobs..."
blobs_data = JSON.parse(File.read(blobs_file))

blobs_imported = 0
blobs_skipped = 0
blobs_data.each do |blob_entry|
  begin
    # Check if blob already exists
    existing = ActiveStorage::Blob.find_by(key: blob_entry['key'])

    if existing
      blobs_skipped += 1
    else
      # Create new blob with specific ID
      blob = ActiveStorage::Blob.new(blob_entry.except('created_at'))
      blob.id = blob_entry['id']
      blob.created_at = blob_entry['created_at']
      blob.save!

      blobs_imported += 1
      puts "  ✅ Blob #{blob.id} (#{blob.filename})"
    end
  rescue => e
    puts "  ❌ Error importing blob #{blob_entry['id']}: #{e.message}"
  end
end

puts "✓ Imported #{blobs_imported} blobs, skipped #{blobs_skipped} existing"
puts ""

# Import attachments
puts "Importing Active Storage Attachments..."
attachments_data = JSON.parse(File.read(attachments_file))

attachments_imported = 0
attachments_skipped = 0
attachments_data.each do |attachment_entry|
  begin
    # Check if attachment already exists
    existing = ActiveStorage::Attachment.find_by(
      record_type: attachment_entry['record_type'],
      record_id: attachment_entry['record_id'],
      name: attachment_entry['name']
    )

    if existing
      attachments_skipped += 1
    else
      # Create new attachment with specific ID
      attachment = ActiveStorage::Attachment.new(attachment_entry.except('created_at'))
      attachment.id = attachment_entry['id']
      attachment.created_at = attachment_entry['created_at']
      attachment.save!

      attachments_imported += 1
      puts "  ✅ Attachment #{attachment.id} (#{attachment.name} for #{attachment.record_type}##{attachment.record_id})"
    end
  rescue => e
    puts "  ❌ Error importing attachment #{attachment_entry['id']}: #{e.message}"
  end
end

puts "✓ Imported #{attachments_imported} attachments, skipped #{attachments_skipped} existing"
puts ""
puts "=== Import Complete ==="
puts "✅ All image metadata has been synced!"
