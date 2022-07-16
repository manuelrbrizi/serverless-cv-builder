output "invoke_url" {
  value = aws_api_gateway_deployment.this.invoke_url
}

output "rest_api_id" {
  value = aws_api_gateway_rest_api.this.id
}

output "resource_id" {
  value = aws_api_gateway_resource.this.id
}