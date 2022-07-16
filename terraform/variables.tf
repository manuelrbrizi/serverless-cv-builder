variable "aws_region" {
  default = "us-east-1"
}

variable "website" {
  default = "mi-pagina-de-cvs-con-terraform"
}

data "archive_file" "lambda" {
  type = "zip"

  source_dir  = "${path.module}/../lambda/files"
  output_path = "${path.module}/../lambda/zip/lambda.zip"
}



