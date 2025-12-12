#!/usr/bin/env ruby
# Complete Database Synchronization Script
# Exports ALL data from local database and imports to production
# This syncs: Products, Topics, ProductTopics, Users, and Active Storage metadata

require 'json'
require 'fileutils'
require 'active_support/all'

class DatabaseSync
  def initialize
    @timestamp = Time.current.strftime('%Y%m%d_%H%M%S')
    @export_dir = Rails.root.join('tmp/db_exports')
  end

  def export_dir
    @export_dir
  end

  def export_all
    puts "=== Complete Database Export ==="
    puts ""
    puts "🔄 Starting comprehensive database export..."
    puts ""

    FileUtils.mkdir_p(export_dir)

    # Export all necessary tables
    export_users
    export_topics
    export_products
    export_product_topics
    export_active_storage_blobs
    export_active_storage_attachments

    puts ""
    puts "✅ Export completed successfully!"
    puts ""
    puts "📁 Exported files:"
    Dir.glob(File.join(export_dir, "*.json")).each do |file|
      size = (File.size(file).to_f / 1024).round(2)
      puts "  - #{File.basename(file)} (#{size} KB)"
    end
    puts ""
  end

  def import_all
    puts "=== Complete Database Import ==="
    puts ""
    puts "🔄 Starting comprehensive database import..."
    puts ""

    # Find the latest exports
    files = Dir.glob(File.join(export_dir, "*_#{@timestamp}_*.json"))

    if files.empty?
      # Try to find the most recent exports (fallback)
      files = Dir.glob(File.join(export_dir, "*.json")).sort.reverse
      if files.empty?
        puts "❌ No export files found in #{export_dir}"
        return
      end
    end

    import_users_from_file(files)
    import_topics_from_file(files)
    import_products_from_file(files)
    import_product_topics_from_file(files)
    import_active_storage_blobs_from_file(files)
    import_active_storage_attachments_from_file(files)

    puts ""
    puts "✅ Import completed successfully!"
    puts ""
  end

  # ============ EXPORT METHODS ============

  def export_users
    puts "📤 Exporting users..."
    users = User.all.map do |user|
      {
        id: user.id,
        email: user.email,
        name: user.name,
        username: user.username,
        role: user.role,
        reputation: user.reputation,
        created_at: user.created_at,
        updated_at: user.updated_at
      }
    end

    file = File.join(export_dir, "users_#{@timestamp}.json")
    File.write(file, JSON.pretty_generate(users))
    puts "  ✓ Exported #{users.count} users"
  end

  def export_topics
    puts "📤 Exporting topics..."
    topics = Topic.all.map do |topic|
      {
        id: topic.id,
        name: topic.name,
        slug: topic.slug,
        created_at: topic.created_at,
        updated_at: topic.updated_at
      }
    end

    file = File.join(export_dir, "topics_#{@timestamp}.json")
    File.write(file, JSON.pretty_generate(topics))
    puts "  ✓ Exported #{topics.count} topics"
  end

  def export_products
    puts "📤 Exporting products..."
    products = Product.all.map do |product|
      {
        id: product.id,
        name: product.name,
        tagline: product.tagline,
        description: product.description,
        status: product.status,
        user_id: product.user_id,
        featured: product.featured,
        key_features: product.key_features,
        pricing_info: product.pricing_info,
        website_url: product.website_url,
        company_name: product.company_name,
        founded_year: product.founded_year,
        headquarters: product.headquarters,
        employee_count: product.employee_count,
        company_description: product.company_description,
        facebook_url: product.facebook_url,
        instagram_url: product.instagram_url,
        tiktok_url: product.tiktok_url,
        github_url: product.github_url,
        votes_count: product.votes_count,
        comments_count: product.comments_count,
        likes_count: product.likes_count,
        created_at: product.created_at,
        updated_at: product.updated_at
      }
    end

    file = File.join(export_dir, "products_#{@timestamp}.json")
    File.write(file, JSON.pretty_generate(products))
    puts "  ✓ Exported #{products.count} products"
  end

  def export_product_topics
    puts "📤 Exporting product-topic associations..."
    associations = ProductTopic.all.map do |pt|
      {
        id: pt.id,
        product_id: pt.product_id,
        topic_id: pt.topic_id,
        created_at: pt.created_at,
        updated_at: pt.updated_at
      }
    end

    file = File.join(export_dir, "product_topics_#{@timestamp}.json")
    File.write(file, JSON.pretty_generate(associations))
    puts "  ✓ Exported #{associations.count} product-topic associations"
  end

  def export_active_storage_blobs
    puts "📤 Exporting Active Storage blobs..."
    blobs = ActiveStorage::Blob.all.map do |blob|
      {
        id: blob.id,
        key: blob.key,
        filename: blob.filename.to_s,
        content_type: blob.content_type,
        metadata: blob.metadata,
        byte_size: blob.byte_size,
        checksum: blob.checksum,
        created_at: blob.created_at,
        service_name: blob.service_name
      }
    end

    file = File.join(export_dir, "active_storage_blobs_#{@timestamp}.json")
    File.write(file, JSON.pretty_generate(blobs))
    puts "  ✓ Exported #{blobs.count} blobs"
  end

  def export_active_storage_attachments
    puts "📤 Exporting Active Storage attachments..."
    attachments = ActiveStorage::Attachment.all.map do |attachment|
      {
        id: attachment.id,
        name: attachment.name,
        record_type: attachment.record_type,
        record_id: attachment.record_id,
        blob_id: attachment.blob_id,
        created_at: attachment.created_at
      }
    end

    file = File.join(export_dir, "active_storage_attachments_#{@timestamp}.json")
    File.write(file, JSON.pretty_generate(attachments))
    puts "  ✓ Exported #{attachments.count} attachments"
  end

  # ============ IMPORT METHODS ============

  def import_users_from_file(files)
    puts "📥 Importing users..."
    file = files.find { |f| f.include?('users_') }
    return unless file && File.exist?(file)

    users_data = JSON.parse(File.read(file))
    imported = 0
    skipped = 0

    users_data.each do |user_data|
      user = User.find_or_create_by(id: user_data['id']) do |u|
        u.email = user_data['email']
        u.name = user_data['name']
        u.username = user_data['username']
        u.role = user_data['role']
        u.reputation = user_data['reputation']
      end

      if user.new_record?
        user.save!
        imported += 1
      else
        skipped += 1
      end
    end

    puts "  ✓ Imported #{imported} users, skipped #{skipped} existing"
  end

  def import_topics_from_file(files)
    puts "📥 Importing topics..."
    file = files.find { |f| f.include?('topics_') }
    return unless file && File.exist?(file)

    topics_data = JSON.parse(File.read(file))
    imported = 0
    skipped = 0

    topics_data.each do |topic_data|
      topic = Topic.find_or_create_by(id: topic_data['id']) do |t|
        t.name = topic_data['name']
        t.slug = topic_data['slug']
      end

      if topic.new_record?
        topic.save!
        imported += 1
      else
        skipped += 1
      end
    end

    puts "  ✓ Imported #{imported} topics, skipped #{skipped} existing"
  end

  def import_products_from_file(files)
    puts "📥 Importing products..."
    file = files.find { |f| f.include?('products_') }
    return unless file && File.exist?(file)

    products_data = JSON.parse(File.read(file))
    imported = 0
    skipped = 0

    products_data.each do |product_data|
      product = Product.find_or_create_by(id: product_data['id']) do |p|
        p.name = product_data['name']
        p.tagline = product_data['tagline']
        p.description = product_data['description']
        p.status = product_data['status']
        p.user_id = product_data['user_id']
        p.featured = product_data['featured']
        p.key_features = product_data['key_features']
        p.pricing_info = product_data['pricing_info']
        p.website_url = product_data['website_url']
        p.company_name = product_data['company_name']
        p.founded_year = product_data['founded_year']
        p.headquarters = product_data['headquarters']
        p.employee_count = product_data['employee_count']
        p.company_description = product_data['company_description']
        p.facebook_url = product_data['facebook_url']
        p.instagram_url = product_data['instagram_url']
        p.tiktok_url = product_data['tiktok_url']
        p.github_url = product_data['github_url']
        p.votes_count = product_data['votes_count']
        p.comments_count = product_data['comments_count']
        p.likes_count = product_data['likes_count']
      end

      if product.new_record?
        # Skip validations since images won't be attached yet during import
        product.save(validate: false)
        imported += 1
      else
        skipped += 1
      end
    end

    puts "  ✓ Imported #{imported} products, skipped #{skipped} existing"
  end

  def import_product_topics_from_file(files)
    puts "📥 Importing product-topic associations..."
    file = files.find { |f| f.include?('product_topics_') }
    return unless file && File.exist?(file)

    associations_data = JSON.parse(File.read(file))
    imported = 0
    skipped = 0

    associations_data.each do |assoc_data|
      association = ProductTopic.find_or_create_by(
        id: assoc_data['id'],
        product_id: assoc_data['product_id'],
        topic_id: assoc_data['topic_id']
      ) do |pt|
        # Already set in find_or_create_by
      end

      if association.new_record?
        association.save!
        imported += 1
      else
        skipped += 1
      end
    end

    puts "  ✓ Imported #{imported} associations, skipped #{skipped} existing"
  end

  def import_active_storage_blobs_from_file(files)
    puts "📥 Importing Active Storage blobs..."
    file = files.find { |f| f.include?('active_storage_blobs_') }
    return unless file && File.exist?(file)

    blobs_data = JSON.parse(File.read(file))
    imported = 0
    skipped = 0

    blobs_data.each do |blob_data|
      blob = ActiveStorage::Blob.find_or_create_by(id: blob_data['id']) do |b|
        b.key = blob_data['key']
        b.filename = blob_data['filename']
        b.content_type = blob_data['content_type']
        b.metadata = blob_data['metadata'] || {}
        b.byte_size = blob_data['byte_size']
        b.checksum = blob_data['checksum']
        b.service_name = blob_data['service_name']
      end

      if blob.new_record?
        blob.save!
        imported += 1
      else
        skipped += 1
      end
    end

    puts "  ✓ Imported #{imported} blobs, skipped #{skipped} existing"
  end

  def import_active_storage_attachments_from_file(files)
    puts "📥 Importing Active Storage attachments..."
    file = files.find { |f| f.include?('active_storage_attachments_') }
    return unless file && File.exist?(file)

    attachments_data = JSON.parse(File.read(file))
    imported = 0
    skipped = 0

    attachments_data.each do |attachment_data|
      attachment = ActiveStorage::Attachment.find_or_create_by(id: attachment_data['id']) do |a|
        a.name = attachment_data['name']
        a.record_type = attachment_data['record_type']
        a.record_id = attachment_data['record_id']
        a.blob_id = attachment_data['blob_id']
      end

      if attachment.new_record?
        attachment.save!
        imported += 1
      else
        skipped += 1
      end
    end

    puts "  ✓ Imported #{imported} attachments, skipped #{skipped} existing"
  end
end

# Main execution
if __FILE__ == $0
  case ARGV[0]
  when 'export'
    DatabaseSync.new.export_all
  when 'import'
    DatabaseSync.new.import_all
  else
    puts "Usage: rails runner script/sync_complete_database.rb [export|import]"
    puts ""
    puts "Examples:"
    puts "  rails runner script/sync_complete_database.rb export  # Export local database"
    puts "  rails runner script/sync_complete_database.rb import  # Import to production"
  end
end
