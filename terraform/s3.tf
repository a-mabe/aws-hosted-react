# Create the bucket
resource "aws_s3_bucket" "app_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

# resource "aws_s3_bucket_acl" "app_bucket_acl" {
#   bucket = aws_s3_bucket.app_bucket.id
#   acl    = "public-read"
# }

# Setup the website configuration
resource "aws_s3_bucket_website_configuration" "app_bucket_web_config" {
  bucket = aws_s3_bucket.app_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Add the website files
module "website_files" {
  source   = "hashicorp/dir/template"
  base_dir = var.website_root
}

resource "aws_s3_object" "static_files" {
  for_each     = module.website_files.files
  bucket       = var.bucket_name
  key          = each.key
  content_type = each.value.content_type
  source       = each.value.source_path
  content      = each.value.content
  etag         = each.value.digests.md5
  depends_on = [
    aws_s3_bucket.app_bucket
  ]
}

# Output the endpoint
output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.app_bucket_web_config.website_endpoint
}