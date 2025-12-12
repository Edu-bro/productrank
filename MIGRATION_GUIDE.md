# Production R2 Migration Guide

## Current Status

✅ **Local Development Environment:**
- 527 Active Storage blobs fully recovered and verified
- 100% file integrity (all files in flat structure)
- All URLs generating correctly
- Ready for production deployment

❌ **Production (Render):**
- No image files in R2 storage
- Database has orphaned blob records (no actual files)
- Images show as placeholders
- Needs complete file migration

---

## Migration Steps

### Step 1: Verify R2 Credentials (Local)

Run this command locally to verify R2 connectivity:

```bash
RAILS_ENV=development bundle exec rails storage:verify_r2
```

**Expected output:**
```
✅ All environment variables are set
✅ Successfully connected to Cloudflare R2
   Bucket 'pdrank' is accessible
   Current object count: 0 (or shows existing files)
```

**If this fails:**
- Check that R2_ACCESS_KEY_ID, R2_SECRET_ACCESS_KEY, R2_BUCKET, R2_ENDPOINT are set
- Verify credentials are correct
- Check firewall/network access to R2

### Step 2: Migrate Files to R2 (Local)

Once credentials are verified, migrate all 527 image files to R2:

```bash
RAILS_ENV=development bundle exec rails storage:migrate_to_r2
```

**Expected process:**
```
Processing blob 1/527: u83onxvkgqn228vg7mj2mebyzh51... [✓ MIGRATED]
Processing blob 2/527: ct1wmz88z6mjtl3w1ag25m5l32cx... [✓ MIGRATED]
...
Processing blob 527/527: xyz...

Migration completed!
Total blobs:     527
Migrated:        527
Skipped:         0
Errors:          0

✅ All files successfully migrated to Cloudflare R2!
```

**Troubleshooting:**
- If "local file not found": Run `rails storage:verify_files` to diagnose
- If R2 upload fails: Check R2 credentials and bucket permissions
- If some files fail: Note the error messages and try individual files

### Step 3: Update Database Service Names

After files are in R2, update all blob records to use 'cloudflare' service:

```bash
RAILS_ENV=development bundle exec rails runner "
ActiveStorage::Blob.update_all(service_name: 'cloudflare')
puts '✅ Updated #{ActiveStorage::Blob.count} blobs to cloudflare service'
"
```

### Step 4: Deploy to Production

```bash
git add .
git commit -m "Complete R2 migration: All 527 image files uploaded"
git push origin main
```

Render will auto-deploy the changes.

### Step 5: Verify Production

Once deployed to Render, verify images are loading:

1. Visit: https://productrank.onrender.com/products/68
   - Should show product logo
   - Should show 3 product images
   - Should show cover image

2. Visit homepage: https://productrank.onrender.com
   - Should show logos on all product cards

3. Check production logs:
   ```bash
   # In Render Shell
   rails runner "puts 'Blobs: #{ActiveStorage::Blob.count}, Service: #{ActiveStorage::Blob.first&.service_name}'"
   ```

---

## Safety Checks

### Before Migration:

```bash
# 1. Verify local files
RAILS_ENV=development bundle exec rails storage:verify_files

# Expected: All 527 blobs have corresponding files

# 2. Verify R2 access
RAILS_ENV=development bundle exec rails storage:verify_r2

# Expected: Successfully connected, bucket is accessible

# 3. Backup database (optional but recommended)
sqlite3 db/development.sqlite3 ".backup db/development.sqlite3.backup"
```

### During Migration:

```bash
# Monitor the migration progress
# It takes ~5-10 minutes for 527 files depending on file sizes

# If you need to cancel (Ctrl+C is safe)
# Just restart where it left off - skips already uploaded files
```

### After Migration:

```bash
# Verify all files were uploaded
RAILS_ENV=development bundle exec rails runner "
puts 'Total blobs: #{ActiveStorage::Blob.count}'
puts 'Blobs with service=local: #{ActiveStorage::Blob.where(service_name: \"local\").count}'
puts 'Blobs with service=cloudflare: #{ActiveStorage::Blob.where(service_name: \"cloudflare\").count}'
"

# Expected: All 527 blobs with service=cloudflare
```

---

## Timeline

| Step | Environment | Time | Notes |
|------|-------------|------|-------|
| 1 | Local | 1 min | Verify R2 credentials |
| 2 | Local | 5-10 min | Upload 527 files to R2 |
| 3 | Local | <1 min | Update database |
| 4 | Both | 2-3 min | Deploy to Render |
| 5 | Production | 1 min | Verify images load |

**Total time: ~10-15 minutes**

---

## Rollback Plan

If something goes wrong:

1. **Migration fails midway:**
   - Just run the migration again (already uploaded files are skipped)
   - Check error logs to diagnose specific issues

2. **Files in R2 but database not updated:**
   - Run Step 3 again to update service names

3. **Images still not showing in production:**
   - Check that code was deployed
   - Clear browser cache
   - Check Render logs for errors

4. **Complete rollback:**
   - Set `config.active_storage.service = :local` in production (not recommended)
   - Or contact Render support to restore from backup

---

## Database Schema

### Before Migration:
```
Active Storage Blobs:
- ID: 447, Key: u83onxvkgqn228vg7mj2mebyzh51
- Service: 'local'
- File: /storage/u83onxvkgqn228vg7mj2mebyzh51 ✓

Active Storage Attachments:
- ID: 447, Name: 'logo_image'
- Record: Product#68
- Blob: 447
```

### After Migration:
```
Active Storage Blobs:
- ID: 447, Key: u83onxvkgqn228vg7mj2mebyzh51
- Service: 'cloudflare' (updated)
- File: R2 Storage ✓

Active Storage Attachments:
- (unchanged - still points to blob 447)
```

When a user requests the image:
1. Product#68.logo_image → references Attachment#447
2. Attachment#447 → references Blob#447
3. Blob#447 (service='cloudflare') → returns signed URL to R2
4. Browser follows signed URL → gets image from Cloudflare R2 CDN

---

## Q&A

**Q: Will this cause downtime?**
A: No. Files stay in local storage during migration. Only when database is updated (Step 3) does production switch to R2. And it's a simple database update that takes <1 second.

**Q: What about file size limits?**
A: R2 has no file size limits for objects. Your largest images are ~40KB, no issues.

**Q: Do I need to update the code?**
A: No. The code already has `config.active_storage.service = :cloudflare` set for production. Just deploy and it works.

**Q: What if migration fails?**
A: The migration script is idempotent - already uploaded files are skipped. Just run it again. Safe to retry.

**Q: How long does 527 files take?**
A: ~5-10 minutes depending on your internet speed and file sizes. Total size ~19MB.

---

## Support

If you encounter issues during migration:

1. Check R2 credentials are correct
2. Verify local files exist: `RAILS_ENV=development bundle exec rails storage:verify_files`
3. Check R2 access: `RAILS_ENV=development bundle exec rails storage:verify_r2`
4. Review error messages in the migration output
5. Check Render dashboard for any connectivity issues

---

**You're ready to migrate!** Run the commands in order and all images will be live in production within 15 minutes.
