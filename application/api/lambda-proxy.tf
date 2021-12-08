#####
# Get
#####
resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.root_level.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_method.get.resource_id
  http_method = aws_api_gateway_method.get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.terraform_remote_state.lambda_get_results.outputs.invoke_arn
}

resource "aws_api_gateway_method_response" "get_http_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.root_level.id
  http_method = aws_api_gateway_integration.get.http_method
  status_code = "200"
}
resource "aws_api_gateway_integration_response" "get_http_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.root_level.id
  http_method = aws_api_gateway_method_response.get_http_200.http_method
  status_code = aws_api_gateway_method_response.get_http_200.status_code
}

resource "aws_lambda_permission" "get" {
  statement_id  = "AllowAPIGatewayInvoke-${data.terraform_remote_state.lambda_get_results.outputs.function_name}-${aws_api_gateway_method.get.resource_id}-${aws_api_gateway_method.get.http_method}"
  action        = "lambda:InvokeFunction"
  function_name = data.terraform_remote_state.lambda_get_results.outputs.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}

#####
# POST
#####
resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.root_level.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_method.post.resource_id
  http_method = aws_api_gateway_method.post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.terraform_remote_state.lambda_dice_roller.outputs.invoke_arn
}

resource "aws_api_gateway_method_response" "post_http_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.root_level.id
  http_method = aws_api_gateway_integration.post.http_method
  status_code = "200"
}
resource "aws_api_gateway_integration_response" "post_http_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.root_level.id
  http_method = aws_api_gateway_method_response.post_http_200.http_method
  status_code = aws_api_gateway_method_response.post_http_200.status_code
}

resource "aws_lambda_permission" "post" {
  statement_id  = "AllowAPIGatewayInvoke-${data.terraform_remote_state.lambda_dice_roller.outputs.function_name}-${aws_api_gateway_method.post.resource_id}-${aws_api_gateway_method.post.http_method}"
  action        = "lambda:InvokeFunction"
  function_name = data.terraform_remote_state.lambda_dice_roller.outputs.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}
