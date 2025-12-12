# Production Database Sync Guide

## Overview
This guide explains how to sync image metadata (blobs and attachments) from your local development database to the production database on Render.

## Problem Solved
Production database is missing image metadata that exists in the local development database. This causes product images to not display properly in production.

**Status**: ✅ Export files created (531 blobs, 527 attachments)
**Files Location**: `tmp/db_exports/`

## What Gets Synced
- **Active Storage Blobs**: 531 image file records (contains file metadata: id, key, filename, size, etc.)
- **Active Storage Attachments**: 527 image associations (links blobs to products and their attachment types)

### Example - Product #68
- Logo: 1 blob
- Product Images: 3 blobs
- Cover Image: 1 blob
- **Total**: 5 attachments linking these to the product record

## Steps to Complete Sync

### Step 1: Export Local Database (ALREADY DONE ✅)
Local data has been exported to:
```
tmp/db_exports/active_storage_blobs_20251212_061826.json    (186 KB)
tmp/db_exports/active_storage_attachments_20251212_061826.json (88 KB)
```

### Step 2: Deploy Code to Render
```bash
git push origin main
```
This deploys:
- Updated `lib/tasks/db_sync.rake` - database export/import utilities
- New `script/import_image_metadata.rb` - the import script

### Step 3: Upload Export Files to Render (MANUAL STEP)
You need to upload the JSON export files to your Render app. There are two options:

**Option A: Via Git (Recommended)**
1. Commit the export files to git:
   ```bash
   git add tmp/db_exports/
   git commit -m "Add production database sync files"
   git push origin main
   ```
   Then Render will automatically have the files after deploy completes.

**Option B: Via Render Shell**
1. Go to https://dashboard.render.com
2. Select your ProductRank service
3. Click "Shell" tab
4. Create the directory: `mkdir -p tmp/db_exports`
5. Upload files using SCP or create them using the contents from your local machine

### Step 4: Run Import Script in Render Shell
Once the code is deployed and export files are in place:

1. Go to https://dashboard.render.com
2. Select your "productrank" service (the web service)
3. Click "Shell" tab
4. Run the import command:
   ```bash
   rails runner script/import_image_metadata.rb
   ```

Expected output:
```
=== Importing Image Metadata to Production ===

📄 Using files:
  - active_storage_blobs_20251212_061826.json
  - active_storage_attachments_20251212_061826.json

Importing Active Storage Blobs...
✓ Imported 531 blobs, skipped 0 existing

Importing Active Storage Attachments...
✓ Imported 527 attachments, skipped 0 existing

=== Import Complete ===
✅ All image metadata has been synced!
```

### Step 5: Verify Results
After import completes, verify images are now displaying:

1. Visit production: https://productrank.onrender.com/products/68
2. Check that:
   - Product logo appears (was showing placeholder before)
   - Product cover image appears
   - Product gallery images appear
3. Visit homepage: https://productrank.onrender.com
4. Check that product logos appear in the product cards

## Troubleshooting

### Export files not found error
If you get: `Blobs file not found in tmp/db_exports/`

**Solution**: Ensure the JSON export files are in the Render `tmp/db_exports/` directory
- Check: Does `tmp/db_exports/active_storage_blobs_*.json` exist?
- If not, re-run the export locally and upload the files

### Import script hangs or times out
If the script appears to be running too long:
- This is normal - 531 blobs and 527 attachments take time to import
- Wait up to 5 minutes for completion
- If it exceeds 5 minutes, check Render logs for errors

### Duplicate key errors
If you see "Duplicate key" errors:
- This means some metadata was already imported
- The script handles this gracefully and skips duplicates
- This is not an error - it's normal behavior

### Images still not showing after import
If images still don't display after successful import:

1. Clear browser cache: `Cmd+Shift+Delete` (or `Ctrl+Shift+Delete` on Windows)
2. Hard refresh: `Cmd+Shift+R` (or `Ctrl+Shift+R` on Windows)
3. Check that R2 storage actually has the image files:
   ```bash
   # In Render Shell
   rails runner "
   product = Product.find(68)
   puts \"Product 68 Logo Attachment: #{product.logo_image.attached?}\"
   if product.logo_image.attached?
     blob = product.logo_image.blob
     puts \"Blob: #{blob.key}\"
     puts \"Filename: #{blob.filename}\"
   end
   "
   ```

## Database Sync Details

### How It Works
1. **Export** (Development environment):
   - Reads all Active Storage blobs from local SQLite database
   - Reads all Active Storage attachments from local database
   - Exports as JSON files with full metadata

2. **Import** (Production environment):
   - Reads JSON files from `tmp/db_exports/`
   - For each blob: Creates record with same ID to maintain referential integrity
   - For each attachment: Creates association linking blob to product
   - Skips any duplicates (idempotent - safe to run multiple times)

### Why This Approach
- **Safe**: No destructive operations, only inserts
- **Idempotent**: Can be run multiple times safely
- **Portable**: Works between any Rails environments
- **Traceable**: See exactly what gets imported
- **Fast**: Direct database inserts, no file transfers needed

### What About Actual Image Files?
The blob metadata points to files in R2 storage. The actual image files:
- Were originally uploaded to local storage during seeding
- Already exist in R2 production storage (uploaded separately)
- The blob metadata creates the link between the product record and the file in R2

## Support Commands

### Check Database Health (Production)
```bash
# In Render Shell
rails runner "
puts \"=== Production Database Status ===\"
puts \"Active Storage Blobs: #{ActiveStorage::Blob.count}\"
puts \"Active Storage Attachments: #{ActiveStorage::Attachment.count}\"
puts \"Products: #{Product.count}\"
"
```

### Check Specific Product (Production)
```bash
# In Render Shell - check product 68
rails runner "
product = Product.find(68)
puts \"Product 68: #{product.name}\"
puts \"  Has logo: #{product.logo_image.attached?}\"
puts \"  Images: #{product.product_images.count}\"
product.product_images.each_with_index do |img, i|
  puts \"    #{i+1}. #{img.filename}\"
end
"
```

### Re-run Export (if needed)
```bash
# In development environment
RAILS_ENV=development bundle exec rails db:export_image_metadata
```

## Files Reference

| File | Purpose | Size |
|------|---------|------|
| `lib/tasks/db_sync.rake` | Database sync utilities | Updated |
| `script/import_image_metadata.rb` | Main import script | ~5 KB |
| `tmp/db_exports/active_storage_blobs_*.json` | Exported blob data | 186 KB |
| `tmp/db_exports/active_storage_attachments_*.json` | Exported attachment data | 88 KB |

## Timeline
- ✅ Code fixes (image URL generation) - COMPLETED
- ✅ Export script created - COMPLETED
- ✅ Data exported from local DB - COMPLETED
- ✅ Code pushed to production - COMPLETED
- ⏳ **NEXT**: Import script in Render Shell
- 🔄 Verify images display

---

**Questions?** Check the troubleshooting section or review the import script logic in `script/import_image_metadata.rb`
