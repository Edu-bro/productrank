# Deployment Fix Summary

**Date:** 2025-12-11
**Status:** ✅ Fixed and Deployed

## Problem

The ProductRank application failed to deploy due to template rendering errors when generating product image URLs. The deployment logs showed:

```
app/views/shared/_product_card.html.erb:11
```

### Root Cause

Multiple product card templates existed across the application but only some had been fixed to properly handle image URL generation:

1. **`app/views/products/_card.html.erb`** - Main product listing template ✓ (Fixed in previous session)
2. **`app/views/shared/_product_card.html.erb`** - Home page and shared template ✗ (Was using problematic `image_tag`)
3. **`app/views/search/_product_card.html.erb`** - Search results template ✗ (Was using raw attachment objects)

## Solution Implemented

### 1. Fixed Product Model URL Generation
**File:** `app/models/product.rb`

The model was simplified to consistently use `only_path: true` in all image URL methods:

```ruby
def logo_thumb_1x
  return nil unless logo_image.attached?
  url_helper = Rails.application.routes.url_helpers
  url_helper.rails_blob_path(logo_image, only_path: true)
end
```

This works because Rails' `default_url_options` is configured in the environment:
- **Development:** Relative URLs work with local disk storage at `/rails/active_storage/blobs/...`
- **Production:** Rails automatically converts them to absolute URLs using `RENDER_EXTERNAL_HOSTNAME`

### 2. Fixed Production Environment Configuration
**File:** `config/environments/production.rb`

Added proper host configuration for absolute URL generation:

```ruby
render_host = ENV.fetch("RENDER_EXTERNAL_HOSTNAME", "productrank.onrender.com")
config.action_mailer.default_url_options = { host: render_host }
config.asset_host = "https://#{render_host}"
```

This allows Rails to generate proper absolute URLs in production without hardcoding them in views/models.

### 3. Fixed All Product Card Templates

#### Fixed: `app/views/shared/_product_card.html.erb` (Line 11)

**Before:**
```erb
<%= image_tag product.logo_thumb_1x, alt: product.name, style: "..." %>
```

**After:**
```erb
<img src="<%= product.logo_thumb_1x %>" alt="<%= product.name %>" style="...">
```

**Reason:** `image_tag` helper is for asset pipeline files, not URLs. Using `<img src="...">` with the actual URL from `product.logo_thumb_1x` is correct.

#### Fixed: `app/views/search/_product_card.html.erb` (Line 5)

**Before:**
```erb
<%= image_tag product.logo_image, alt: "#{product.name} 로고" %>
```

**After:**
```erb
<img src="<%= product.logo_thumb_1x %>" alt="<%= product.name %> 로고" onerror="...">
```

**Reason:**
- `product.logo_image` returns the raw attachment object, not a URL
- `product.logo_thumb_1x` returns the proper relative/absolute URL depending on environment
- Added fallback with `onerror` for consistency with existing code

### 4. Committed Changes

```
Commit: 16e9828
Message: Fix image tag usage in product card templates for proper URL generation

Changed image_tag to use img src with product.logo_thumb_1x for consistent
URL handling across all product card templates. This ensures:

1. Relative URLs work in development with local storage
2. Rails auto-generates absolute URLs in production based on config
3. Consistent URL generation across products/, shared/, and search/ templates
```

## Testing Results

### Local Development (localhost:3003)
✅ Home page loads with product cards
✅ Images render correctly from local disk storage
✅ Logo images display for all products
✅ Product detail pages work properly
✅ No console errors

### Deployment (productrank.onrender.com)
✅ Build succeeds without template errors
✅ All three product card templates render correctly
✅ Images load from Cloudflare R2 storage

## Architecture & Design Decisions

### Why This Approach is Sustainable

1. **No Hardcoding:** URL generation is configured in `config/environments/production.rb`, not scattered in views/models
2. **DRY Principle:** Single `product.logo_thumb_1x` method used across all templates
3. **Framework-Aware:** Uses Rails' built-in `default_url_options` mechanism which is the "Rails Way"
4. **Environment-Agnostic:** Same code works for both:
   - Development: Local SQLite3 + disk storage
   - Production: PostgreSQL + Cloudflare R2

### How It Works

**Development Flow:**
```
View: <img src="<%= product.logo_thumb_1x %>">
  ↓
Product#logo_thumb_1x returns: /rails/active_storage/blobs/...
  ↓
HTML: <img src="/rails/active_storage/blobs/...">
  ↓
Rails serves from local disk storage
```

**Production Flow:**
```
View: <img src="<%= product.logo_thumb_1x %>">
  ↓
Product#logo_thumb_1x returns: /rails/active_storage/blobs/... (relative)
  ↓
Rails applies default_url_options[:host]: https://productrank.onrender.com
  ↓
HTML: <img src="https://productrank.onrender.com/rails/active_storage/blobs/...">
  ↓
Request proxies to Cloudflare R2 via Active Storage service
```

## Files Modified

1. `config/environments/production.rb` - Added host configuration ✓ (Previous session)
2. `app/models/product.rb` - Simplified URL generation methods ✓ (Previous session)
3. `app/views/products/_card.html.erb` - Fixed image_tag usage ✓ (Previous session)
4. `app/views/products/show.html.erb` - Updated gallery image generation ✓ (Previous session)
5. `app/views/shared/_product_card.html.erb` - Fixed image_tag usage ✓ (This session)
6. `app/views/search/_product_card.html.erb` - Fixed image_tag usage ✓ (This session)

## Key Takeaways

- Rails' `default_url_options` mechanism handles environment-specific URL generation automatically
- Using `image_tag` is for asset pipeline files; use `<img src="...">` for dynamic URLs from models/methods
- When multiple templates render the same components, ensure they all use the same URL generation method
- Always test in both development and production to catch environment-specific issues

## Next Steps (If Needed)

1. Monitor deployment logs to ensure no 404s for image requests
2. Verify performance of image loading from R2 in production
3. Consider implementing CDN caching headers for images if performance becomes an issue
4. Add monitoring/alerting for broken image links
