namespace :db do
  desc "Sync local database to production (for development -> deployment)"
  task sync_to_production: :environment do
    if Rails.env.production?
      puts "❌ This task should NOT run in production!"
      puts "   Use this in development environment only"
      exit 1
    end

    puts "=== Database Sync Tool ==="
    puts ""
    puts "This tool helps sync local development data to production"
    puts ""
    puts "Current Environment: #{Rails.env}"
    puts ""

    # Step 1: Create dump
    puts "Step 1: Creating database dump..."
    timestamp = Time.current.strftime("%Y%m%d_%H%M%S")
    dump_file = "db/dumps/development_#{timestamp}.sql"

    system("mkdir -p db/dumps")

    if system("pg_dump storage/development.sqlite3 > #{dump_file}")
      puts "✅ Dump created: #{dump_file}"
    else
      puts "❌ Failed to create dump"
      exit 1
    end

    puts ""
    puts "Step 2: Export as CSV for safe import"
    puts ""

    # Export tables as CSV
    Rake::Task["db:export_csv"].invoke

    puts ""
    puts "Step 3: Instructions for Render deployment"
    puts ""
    puts "Manual Steps:"
    puts "1. Log in to Render Dashboard: https://dashboard.render.com"
    puts "2. Select your PostgreSQL database"
    puts "3. Go to 'Connections' tab"
    puts "4. Copy the connection string"
    puts "5. Use: psql <connection_string> < #{dump_file}"
    puts ""
    puts "OR use the built-in Render sync:"
    puts "1. In your Render project settings"
    puts "2. Add environment variable DATABASE_URL from PostgreSQL"
    puts "3. Deploy again"
    puts ""
  end

  desc "Export tables as CSV for data inspection"
  task export_csv: :environment do
    puts "=== Exporting Tables as CSV ==="
    puts ""

    csv_dir = "db/exports/#{Time.current.strftime('%Y%m%d_%H%M%S')}"
    system("mkdir -p #{csv_dir}")

    tables = [
      :users,
      :products,
      :topics,
      :product_topics,
      :active_storage_blobs,
      :active_storage_attachments
    ]

    tables.each do |table|
      model = table.to_s.camelize.singularize.constantize
      begin
        require 'csv'

        csv_path = "#{csv_dir}/#{table}.csv"
        records = model.all

        if records.any?
          CSV.open(csv_path, 'w') do |csv|
            # Header
            csv << records.first.attributes.keys

            # Data
            records.each do |record|
              csv << record.attributes.values
            end
          end

          puts "✅ #{table}: #{records.count} records → #{csv_path}"
        else
          puts "⚪ #{table}: 0 records (skipped)"
        end
      rescue => e
        puts "❌ #{table}: Error - #{e.message}"
      end
    end

    puts ""
    puts "Exports saved to: #{csv_dir}/"
    puts ""
    puts "Next: Upload these CSV files to Render and import"
  end

  desc "Import CSV data into database"
  task import_csv: :environment do
    csv_dir = ENV['CSV_DIR'] || 'db/exports'

    puts "=== Importing CSV Data ==="
    puts "Source: #{csv_dir}"
    puts ""

    # This should be used carefully in production
    # Usually done via Render's UI or API

    puts "⚠️  CSV import should be done via Render UI or API"
    puts "   Contact support if data migration needed"
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
