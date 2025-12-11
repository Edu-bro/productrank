# Disabled: S3Service not available without aws-sdk-s3 gem
# This file was trying to extend S3Service which requires the aws-sdk-s3 gem
# Since we're using Cloudflare R2 directly via storage.yml, this custom service isn't needed

# module ActiveStorage
#   class Service::OrganizedS3Service < Service::S3Service
#     # Override the key generation to create organized folder structure
#     # Instead of: uu/5p/uu5pm5wp6f3wfh42yrpkhvt01gdt
#     # Generate: products/logos/1/uuid.png or products/images/1/uuid.jpg
#
#     def upload(key, io, checksum: nil, disposition: nil, filename: nil, custom_metadata: nil)
#       # Organize files by type and resource
#       organized_key = organize_key(key, filename)
#       super(organized_key, io, checksum: checksum, disposition: disposition, filename: filename, custom_metadata: custom_metadata)
#     end
#
#     def download(key, &block)
#       organized_key = organize_key(key)
#       super(organized_key, &block)
#     end
#
#     def delete(key)
#       organized_key = organize_key(key)
#       super(organized_key)
#     end
#
#     def exist?(key)
#       organized_key = organize_key(key)
#       super(organized_key)
#     end
#
#     private
#
#     def organize_key(key, filename = nil)
#       # Parse the blob information from the database
#       # Format: products/logos/product_id/original_filename
#       # Format: products/images/product_id/original_filename
#       # Format: users/avatars/user_id/original_filename
#
#       # This would need access to the blob record to determine type
#       # For now, return original key (can be enhanced)
#       key
#     end
#   end
# end
