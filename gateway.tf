resource "aws_api_gateway_rest_api" "aws-api-gateway" {
  name        = "aws-api-gateway"
  description = "AWS API gateway"
}

resource "aws_api_gateway_resource" "aws-api-gateway-resource" {
  rest_api_id = aws_api_gateway_rest_api.aws-api-gateway.id
  parent_id   = aws_api_gateway_rest_api.aws-api-gateway.root_resource_id
  path_part   = "endpoint"
}

resource "aws_api_gateway_method" "aws-api-gateway-method" {
  rest_api_id   = aws_api_gateway_rest_api.aws-api-gateway.id
  resource_id   = aws_api_gateway_resource.aws-api-gateway-resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.aws-api-gateway-authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.aws-api-gateway.id
  resource_id = aws_api_gateway_method.aws-api-gateway-method.resource_id
  http_method = aws_api_gateway_method.aws-api-gateway-method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.aws-api-gateway.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "aws-api-gateway" {
  depends_on = [
    "aws_api_gateway_integration.lambda"
  ]

  rest_api_id = aws_api_gateway_rest_api.aws-api-gateway.id
  stage_name  = "test"

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.aws-api-gateway-resource.id,
      aws_api_gateway_method.aws-api-gateway-method.id,
      aws_api_gateway_integration.lambda.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_authorizer" "aws-api-gateway-authorizer" {
  name            = "aws-api-gateway-authorizer"
  rest_api_id     = aws_api_gateway_rest_api.aws-api-gateway.id
  type            = "COGNITO_USER_POOLS"
  identity_source = "method.request.header.Authorization"
  provider_arns   = [aws_cognito_user_pool.cognito-user-pool.arn]
}


resource "aws_api_gateway_usage_plan" "aws-api-gateway-usage-plan" {
  name = "aws-api-gateway-usage-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.aws-api-gateway.id
    stage  = aws_api_gateway_deployment.aws-api-gateway.stage_name
  }
}

resource "aws_api_gateway_api_key" "aws-api-gateway-api-key" {
  name = "aws-api-gateway-api-key"
}

resource "aws_api_gateway_usage_plan_key" "aws-api-gateway-usage-paln-key" {
  key_id        = aws_api_gateway_api_key.aws-api-gateway-api-key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.aws-api-gateway-usage-plan.id
}