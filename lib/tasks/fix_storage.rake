namespace :storage do
  desc "Reorganize files from hierarchical to flat structure"
  task reorganize_files: :environment do
    if Rails.env.production?
      puts "❌ This task should only run in development!"
      exit 1
    end

    puts "=== Starting File Reorganization ==="
    puts ""

    storage_root = Rails.root.join('storage')

    unless Dir.exist?(storage_root)
      puts "❌ Storage directory not found: #{storage_root}"
      exit 1
    end

    puts "📁 Scanning: #{storage_root}"

    # Find all files in subdirectories
    files_to_move = Dir.glob(File.join(storage_root, '**', '*')).select { |f| File.file?(f) }

    puts "📊 Found #{files_to_move.count} files in subdirectories"
    puts ""

    moved = 0
    errors = []

    files_to_move.each_with_index do |file_path, index|
      begin
        filename = File.basename(file_path)
        new_path = File.join(storage_root, filename)

        # Skip if already in root directory
        if File.dirname(file_path) == storage_root
          puts "⚪ Already in root: #{filename}"
          next
        end

        # Check for conflicts
        if File.exist?(new_path)
          errors << "Conflict: #{filename} already exists in root"
          puts "⚠️  Conflict: #{filename}"
          next
        end

        # Move file
        FileUtils.mv(file_path, new_path)
        moved += 1

        if (index + 1) % 50 == 0
          puts "✓ Moved #{index + 1}/#{files_to_move.count} files..."
        end
      rescue => e
        errors << "Error moving #{file_path}: #{e.message}"
        puts "❌ Error: #{e.message}"
      end
    end

    puts ""
    puts "=== Cleaning Up Empty Directories ==="

    # Remove empty directories
    Dir.glob(File.join(storage_root, '**', '*')).reverse.each do |dir|
      next unless Dir.exist?(dir)
      next unless Dir.empty?(dir)

      begin
        Dir.rmdir(dir)
        puts "🗑️  Removed: #{File.basename(dir)}"
      rescue => e
        # Skip directories that can't be removed
      end
    end

    puts ""
    puts "=== Reorganization Complete ==="
    puts ""
    puts "📊 Results:"
    puts "  - Files moved: #{moved}/#{files_to_move.count}"

    if errors.any?
      puts "  - Errors: #{errors.count}"
      puts ""
      puts "⚠️  Error Details:"
      errors.each { |err| puts "  - #{err}" }
    else
      puts "  - Errors: 0"
    end

    puts ""
  end

  desc "Verify all Active Storage blobs have corresponding files"
  task verify_files: :environment do
    puts "=== Verifying File Integrity ==="
    puts ""

    storage_root = Rails.root.join('storage')
    missing = []
    found = 0

    ActiveStorage::Blob.where(service_name: 'local').each do |blob|
      path = storage_root.join(blob.key)

      if File.exist?(path)
        found += 1
      else
        missing << { id: blob.id, key: blob.key, filename: blob.filename }
      end
    end

    total = ActiveStorage::Blob.where(service_name: 'local').count

    puts "📊 Results:"
    puts "  - Total blobs (local service): #{total}"
    puts "  - Files found: #{found}"
    puts "  - Files missing: #{missing.count}"
    puts ""

    if missing.any?
      puts "⚠️  Missing Files:"
      missing.each do |blob|
        puts "  - Blob ID #{blob[:id]}: #{blob[:filename]} (key: #{blob[:key]})"
      end
      puts ""
      puts "❌ File integrity check FAILED"

      # Suggest action
      if found > 0 && missing.count < total / 2
        puts ""
        puts "💡 Suggestion: Some files exist but others are missing."
        puts "   This suggests incomplete reorganization or data loss."
        puts ""
        puts "   Actions to take:"
        puts "   1. Restore from backup if available"
        puts "   2. Re-upload missing images"
        puts "   3. Delete orphaned blob records"
      end
    else
      puts "✅ File integrity check PASSED"
      puts ""
      puts "All #{total} blobs have corresponding files."
    end

    puts ""
  end

  desc "List all files in storage and their blob matches"
  task list_files: :environment do
    puts "=== Storage Inventory ==="
    puts ""

    storage_root = Rails.root.join('storage')
    files = Dir.glob(File.join(storage_root, '*')).select { |f| File.file?(f) }

    puts "Physical Files: #{files.count}"
    puts ""

    blob_keys = ActiveStorage::Blob.pluck(:key)

    matched = 0
    unmatched = 0

    files.each do |file|
      filename = File.basename(file)
      size = File.size(file)

      if blob_keys.include?(filename)
        matched += 1
        status = "✓"
      else
        unmatched += 1
        status = "✗"
      end

      # Only show first 20, then summary
      if matched + unmatched <= 20
        puts "#{status} #{filename} (#{size} bytes)"
      end
    end

    puts "  ... and #{files.count - 20} more files" if files.count > 20

    puts ""
    puts "Summary:"
    puts "  - Matched to blobs: #{matched}"
    puts "  - Not in database: #{unmatched}"
    puts ""
  end

  desc "Remove orphaned Active Storage blobs (no attachments)"
  task clean_orphaned_blobs: :environment do
    if Rails.env.production?
      puts "❌ This task should only run in development!"
      exit 1
    end

    puts "=== Cleaning Orphaned Blobs ==="
    puts ""

    orphaned = ActiveStorage::Blob.left_outer_joins(:attachments)
                                  .where(active_storage_attachments: { id: nil })

    puts "📊 Found #{orphaned.count} orphaned blobs"
    puts ""

    if orphaned.any?
      puts "Orphaned blob IDs: #{orphaned.pluck(:id).join(', ')}"
      puts ""

      storage_root = Rails.root.join('storage')
      deleted_count = 0

      orphaned.each do |blob|
        begin
          # Delete file if exists
          path = storage_root.join(blob.key)
          if File.exist?(path)
            File.delete(path)
          end

          # Delete blob record
          blob.destroy
          deleted_count += 1

          puts "✓ Deleted blob #{blob.id} (#{blob.filename})"
        rescue => e
          puts "❌ Error deleting blob #{blob.id}: #{e.message}"
        end
      end

      puts ""
      puts "✅ Deleted #{deleted_count} orphaned blobs"
    else
      puts "✅ No orphaned blobs found"
    end

    puts ""
  end

  desc "Analyze storage structure issues"
  task analyze: :environment do
    puts "=== Storage Architecture Analysis ==="
    puts ""

    storage_root = Rails.root.join('storage')

    # Count directory structure
    all_paths = Dir.glob(File.join(storage_root, '**', '*'))
    files = all_paths.select { |f| File.file?(f) }
    dirs = all_paths.select { |d| Dir.exist?(d) }

    puts "📁 Directory Structure:"
    puts "  - Root level files: #{Dir.glob(File.join(storage_root, '*')).select { |f| File.file?(f) }.count}"
    puts "  - Subdirectories: #{dirs.count - 1}"
    puts "  - Total files: #{files.count}"
    puts ""

    # Blob statistics
    blobs = ActiveStorage::Blob.all
    puts "📊 Blob Statistics:"
    puts "  - Total blobs: #{blobs.count}"
    puts "  - By service:"
    ActiveStorage::Blob.group(:service_name).count.each do |service, count|
      puts "    - #{service}: #{count}"
    end
    puts ""

    # Attachment statistics
    attachments = ActiveStorage::Attachment.all
    puts "📎 Attachment Statistics:"
    puts "  - Total attachments: #{attachments.count}"
    puts "  - By name:"
    ActiveStorage::Attachment.group(:name).count.each do |name, count|
      puts "    - #{name}: #{count}"
    end
    puts ""

    # Data quality
    orphaned = blobs.select { |b| b.attachments.empty? }
    products_without_images = Product.left_outer_joins(:logo_image_attachment, :product_images_attachments)
                                    .distinct
                                    .where(active_storage_attachments: { id: nil })

    puts "🔍 Data Quality:"
    puts "  - Orphaned blobs: #{orphaned.count}"
    puts "  - Products without images: #{products_without_images.count}"
    puts ""

    # File-blob mapping
    blob_keys = blobs.pluck(:key).to_set
    physical_files = Dir.glob(File.join(storage_root, '*')).select { |f| File.file?(f) }.map { |f| File.basename(f) }.to_set

    puts "🔗 File-Blob Mapping:"
    puts "  - Blobs with matching files: #{(blob_keys & physical_files).count}"
    puts "  - Blobs without files: #{(blob_keys - physical_files).count}"
    puts "  - Files without blob records: #{(physical_files - blob_keys).count}"
    puts ""

    if (blob_keys - physical_files).count > 0
      puts "⚠️  WARNING: #{(blob_keys - physical_files).count} blobs are missing their files!"
      puts "   This will cause 404 errors when images are requested."
    end

    if (physical_files - blob_keys).count > 0
      puts "ℹ️  INFO: #{(physical_files - blob_keys).count} files exist but aren't in the database."
      puts "   These are orphaned files that can be safely deleted."
    end

    puts ""
  end
end
