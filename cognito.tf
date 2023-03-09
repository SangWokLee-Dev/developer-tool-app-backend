resource "aws_cognito_user_pool" "cognito-user-pool" {
  name = "trams-backend-user-pool"

  username_attributes = [
    "email"
  ]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_message        = "Your verification code is {####}"
    email_subject        = "Verify your email for cognito-user-pool"
    sms_message          = "Your verification code is {####}"
  }
}

resource "aws_cognito_user_pool_client" "cognito-user-pool-client" {
  name                                 = "trams-backend-user-pool-client"
  user_pool_id                         = aws_cognito_user_pool.cognito-user-pool.id
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid"]
  callback_urls                        = ["https://example.com/callback"]
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "cognito-user-pool-domain" {
  domain       = "domain-auth"
  user_pool_id = aws_cognito_user_pool.cognito-user-pool.id
}

output "user_pool_id" {
  value = aws_cognito_user_pool.cognito-user-pool.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.cognito-user-pool-client.id
}