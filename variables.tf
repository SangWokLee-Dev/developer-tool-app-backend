variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-2"
}

variable "aws_cognito_name" {
  type        = string
  description = "AWS Cognito name"
  default     = "cognito-user-pool"
}
variable "aws_cognito_domain" {
  type        = string
  description = "AWS Cognito domain"
  default     = "cogntio-user"
}