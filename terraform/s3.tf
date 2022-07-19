locals {
  buckets = {
    website_logs = {
      bucket_name = "log.${var.website}.com"
      acl         = "log-delivery-write"
    }
    website = {
      bucket_name = "${var.website}.com"
      acl         = "public-read"
      policy      = data.aws_iam_policy_document.website.json
      website = {
        index_document = "index.html"
        error_document = "error.html"
      }
      logging = {
        target_bucket = "log.${var.website}.com"
        target_prefix = "${var.website}/"
      }
      with_files     = true
      files_root     = "../webapp"
      template_files = data.template_file.website_files
    }
    www_redirect = {
      bucket_name = "www.${var.website}.com"
      acl         = "public-read"
      policy      = data.aws_iam_policy_document.www.json

      website = {
        redirect_all_requests_to = "http://${var.website}.com.s3-website-${var.aws_region}.amazonaws.com"
      }
    }
    lambda_bucket = {
      bucket_name = "${var.website}-lambda-bucket"
      acl         = "private"
      with_files  = true
      files_root  = "${path.root}/../lambda/zip"
    }
  }
}

data "template_file" "website_files" {
  for_each = fileset("${path.root}/../webbapp", "*.html")

  vars = {
    # API_ENDPOINT     = module.api["lambda_api"].invoke_url
    # COGNITO_ENDPOINT = module.cognito["main_pool"].endpoint
    # BUCKET_ENDPOINT  = "${var.website}.com"
  }
}

data "aws_iam_policy_document" "website" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::${var.website}.com/*"
    ]
  }
}

data "aws_iam_policy_document" "www" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::www.${var.website}.com/*"
    ]
  }
}

module "s3" {
  source         = "./modules/s3"
  for_each       = local.buckets
  bucket_name    = each.value.bucket_name
  acl            = try(each.value.acl, "private")
  policy         = try(each.value.policy, "")
  logging        = try(each.value.logging, {})
  website        = try(each.value.website, {})
  files_root     = try(each.value.files_root, "")
  with_files     = try(each.value.with_files, false)
  template_files = try(each.value.template_files, {})
}
