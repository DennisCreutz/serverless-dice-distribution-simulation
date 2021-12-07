resource "aws_api_gateway_method" "this" {
  rest_api_id   = var.rest_api_lambda_function.rest_api_id
  resource_id   = var.rest_api_lambda_function.resource_id
  http_method   = var.rest_api_lambda_function.http_method
  authorization = var.rest_api_lambda_function.authorization
  authorizer_id = var.rest_api_lambda_function.authorizer_id

  request_parameters = var.rest_api_lambda_function.request_parameters
  request_models = var.rest_api_lambda_function.request_model != null ? {
    "${var.rest_api_lambda_function.request_model.content_type}" : var.rest_api_lambda_function.request_model.model_name
  } : null

  request_validator_id = var.rest_api_lambda_function.validator_id
}

resource "aws_api_gateway_integration" "this" {
  rest_api_id = var.rest_api_lambda_function.rest_api_id
  resource_id = aws_api_gateway_method.this.resource_id
  http_method = aws_api_gateway_method.this.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.rest_api_lambda_function.lambda_invoke_arn
}

resource "aws_api_gateway_method_response" "http_200" {
  rest_api_id = var.rest_api_lambda_function.rest_api_id
  resource_id = var.rest_api_lambda_function.resource_id
  http_method = aws_api_gateway_integration.this.http_method
  status_code = "200"

  response_models = {
    "${var.rest_api_lambda_function.response_model_200.content_type}" : var.rest_api_lambda_function.response_model_200.model_name
  }

  response_parameters = var.rest_api_lambda_function.enable_cors ? {
    "method.response.header.Access-Control-Allow-Origin" = false
  } : null
}
resource "aws_api_gateway_integration_response" "http_200" {
  rest_api_id = var.rest_api_lambda_function.rest_api_id
  resource_id = var.rest_api_lambda_function.resource_id
  http_method = aws_api_gateway_method_response.http_200.http_method
  status_code = aws_api_gateway_method_response.http_200.status_code

  response_templates = {
    "application/json" = ""
  }

  response_parameters = var.rest_api_lambda_function.enable_cors ? {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } : null
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowAPIGatewayInvoke-${var.rest_api_lambda_function.lambda_alias_name}-${aws_api_gateway_method.this.resource_id}-${aws_api_gateway_method.this.http_method}"
  action        = "lambda:InvokeFunction"
  function_name = var.rest_api_lambda_function.lambda_function_name
  qualifier     = var.rest_api_lambda_function.lambda_alias_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${var.rest_api_lambda_function.rest_api_execution_arn}/*/*"
}


