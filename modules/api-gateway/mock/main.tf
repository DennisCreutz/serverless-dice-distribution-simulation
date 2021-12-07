resource "aws_api_gateway_method" "this" {
  rest_api_id   = var.mock_function.rest_api_id
  resource_id   = var.mock_function.resource_id
  http_method   = var.mock_function.http_method
  authorization = var.mock_function.authorization
  authorizer_id = var.mock_function.authorizer_id

  request_parameters = var.mock_function.request_parameters
  request_models = var.mock_function.request_model != null ? {
    "${var.mock_function.request_model.content_type}" : var.mock_function.request_model.model_name
  } : null

  request_validator_id = var.mock_function.validator_id
}

resource "aws_api_gateway_integration" "this" {
  rest_api_id = var.mock_function.rest_api_id
  resource_id = aws_api_gateway_method.this.resource_id
  http_method = aws_api_gateway_method.this.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_method_response" "http_200" {
  rest_api_id = var.mock_function.rest_api_id
  resource_id = var.mock_function.resource_id
  http_method = aws_api_gateway_integration.this.http_method
  status_code = "200"

  response_models = {
    "${var.mock_function.response_model_200.content_type}" : var.mock_function.response_model_200.model_name
  }

  response_parameters = local.method_response_parameters
}
resource "aws_api_gateway_integration_response" "http_200" {
  rest_api_id = var.mock_function.rest_api_id
  resource_id = var.mock_function.resource_id
  http_method = aws_api_gateway_method_response.http_200.http_method
  status_code = aws_api_gateway_method_response.http_200.status_code

  response_templates = {
    "${var.mock_function.mock_response_type}" = var.mock_function.mock_response
  }

  response_parameters = local.integration_response_parameters
}
