resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = var.acl
  policy = var.policy

  dynamic "website" {
    for_each = length(var.website) > 0 ? [1] : []
    content {
      index_document           = try(var.website.index_document, null)
      error_document           = try(var.website.error_document, null)
      redirect_all_requests_to = try(var.website.redirect_all_requests_to, null)
    }
  }

  dynamic "logging" {
    for_each = length(var.logging) > 0 ? (length(var.logging.target_bucket) > 0 ? [1] : []) : []
    content {
      target_bucket = try(var.logging.target_bucket, null)
      target_prefix = try(var.logging.target_prefix, null)
    }
  }
}

locals {
  mime_types = jsondecode(file("${path.module}/mime.json"))
}

resource "aws_s3_object" "files" {
  for_each = var.with_files ? fileset(var.files_root, "**") : []

  bucket = aws_s3_bucket.this.id

  key    = each.key
  source = "${var.files_root}/${each.key}"
  acl    = try(var.acl, "private")

  etag         = filemd5("${var.files_root}/${each.key}")
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.key), "text/plain")
}

resource "aws_s3_object" "template_files" {
  for_each = length(var.template_files) > 0 ? var.template_files : {}

  bucket = aws_s3_bucket.this.id

  key     = each.key
  content = each.value.rendered
  acl     = try(var.acl, "private")

  etag         = filemd5("${var.files_root}/${each.key}")
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.key), "text/plain")
}
