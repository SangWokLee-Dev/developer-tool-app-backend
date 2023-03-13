variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-2"
}

variable "aws_cognito_user_pool_name" {
  type        = string
  description = "AWS Cognito user pool name"
  default     = "cognito-user-pool"
}
variable "aws_cognito_user_pool_client_name" {
  type        = string
  description = "AWS Cognito user pool client name"
  default     = "cognito-user-pool-client"
}
variable "aws_cognito_user_pool_client_allowed_oauth_flows" {
  type        = list(string)
  description = "AWS Cognito user pool client allowed oauth flows"
  default     = ["code"]
}
variable "aws_cognito_user_pool_client_callback_urls" {
  type        = list(string)
  description = "AWS Cognito user pool client callback urls"
  default     = ["https://example.com/callback"]
}
variable "aws_cognito_user_pool_domain" {
  type        = string
  description = "AWS Cognito user pool domain domain"
  default     = "cogntio-user"
}