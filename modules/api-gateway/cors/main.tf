resource "aws_api_gateway_method" "cors_method" {
  rest_api_id   = var.api
  resource_id   = var.resource
  http_method   = "OPTIONS"
  authorization = "NONE"

  request_parameters = var.request_parameters
}

resource "aws_api_gateway_integration" "cors_integration" {
  rest_api_id = var.api
  resource_id = var.resource
  http_method = aws_api_gateway_method.cors_method.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = <<EOF
{ "statusCode": 200 }
EOF

  }
}

resource "aws_api_gateway_method_response" "cors_method_response" {
  rest_api_id = var.api
  resource_id = var.resource
  http_method = aws_api_gateway_method.cors_method.http_method

  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "cors_integration_response" {
  rest_api_id = var.api
  resource_id = aws_api_gateway_method.cors_method.resource_id
  http_method = aws_api_gateway_method.cors_method.http_method

  status_code = aws_api_gateway_method_response.cors_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'${local.headers}'"
    "method.response.header.Access-Control-Allow-Methods" = "'${local.methods}'"
    "method.response.header.Access-Control-Allow-Origin"  = "'${var.origin}'"
  }
}

resource "aws_api_gateway_gateway_response" "cors_default_4XX" {
  rest_api_id   = var.api
  response_type = "DEFAULT_4XX"

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'${local.headers}'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'${local.methods}'"
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'${var.origin}'"
  }

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }
}

resource "aws_api_gateway_gateway_response" "cors_default_5XX" {
  rest_api_id   = var.api
  response_type = "DEFAULT_5XX"

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'${local.headers}'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'${local.methods}'"
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'${var.origin}'"
  }

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }
}
