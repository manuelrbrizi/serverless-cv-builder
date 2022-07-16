output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "bucket_id" {
  value = aws_s3_bucket.this.id
}

output "bucket_objects" {
  value = aws_s3_object.this
}

output "bucket_domain_name" {
  value = aws_s3_bucket.this.website_endpoint
}

output "arn" {
  value = aws_s3_bucket.this.arn
}