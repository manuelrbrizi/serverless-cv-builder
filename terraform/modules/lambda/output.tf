output "invoke_arn" {
  description = "Invoke URL for API Gateway stage."

  value = aws_lambda_function.this.invoke_arn
}

output "id" {
  description = "id for API Gateway stage."

  value = aws_lambda_function.this.id
}

output "arn" {
  description = "arn for API Gateway stage."

  value = aws_lambda_function.this.arn
}

output "handler" {
  description = "handler for API Gateway stage."

  value = aws_lambda_function.this.handler
}


