module "lambdas" {
  count  = length(var.lambda_functions)
  source = "./lambda-proxy"

  rest_api_lambda_function = {
    rest_api_id            = aws_api_gateway_rest_api.this.id
    rest_api_execution_arn = aws_api_gateway_rest_api.this.execution_arn
    validator_id           = aws_api_gateway_request_validator.this.id
    authorizer_id          = var.cognito_user_pool_arn == null ? null : aws_api_gateway_authorizer.this[0].id

    resource_id = local.path_list[var.lambda_functions[count.index].path_level][var.lambda_functions[count.index].path_index].id

    http_method          = var.lambda_functions[count.index].http_method
    authorization        = var.lambda_functions[count.index].authorization
    request_parameters   = var.lambda_functions[count.index].request_parameters
    request_model        = var.lambda_functions[count.index].request_model
    response_model_200   = var.lambda_functions[count.index].response_model_200
    lambda_invoke_arn    = var.lambda_functions[count.index].lambda_invoke_arn
    lambda_function_name = var.lambda_functions[count.index].lambda_function_name
    lambda_alias_name    = var.lambda_functions[count.index].lambda_alias_name
    enable_cors          = var.lambda_functions[count.index].enable_cors
  }

  depends_on = [
    aws_api_gateway_model.this,
    aws_api_gateway_resource.root_level,
    aws_api_gateway_resource.first_child_level,
    aws_api_gateway_resource.second_child_level,
    aws_api_gateway_resource.third_child_level,
    aws_api_gateway_resource.fourth_child_level,
    aws_api_gateway_resource.fifth_child_level,
    aws_api_gateway_resource.sixth_child_level,
    aws_api_gateway_authorizer.this
  ]
}

module "mocks" {
  count  = length(var.mock_functions)
  source = "./mock"

  mock_function = {
    rest_api_id            = aws_api_gateway_rest_api.this.id
    rest_api_execution_arn = aws_api_gateway_rest_api.this.execution_arn
    validator_id           = aws_api_gateway_request_validator.this.id
    authorizer_id          = var.cognito_user_pool_arn == null ? null : aws_api_gateway_authorizer.this[0].id

    resource_id = local.path_list[var.mock_functions[count.index].path_level][var.mock_functions[count.index].path_index].id

    http_method        = var.mock_functions[count.index].http_method
    authorization      = var.mock_functions[count.index].authorization
    request_parameters = var.mock_functions[count.index].request_parameters
    request_model      = var.mock_functions[count.index].request_model
    response_model_200 = var.mock_functions[count.index].response_model_200
    mock_response      = var.mock_functions[count.index].mock_response
    mock_response_type = var.mock_functions[count.index].mock_response_type
    enable_cors        = var.mock_functions[count.index].enable_cors
  }

  depends_on = [
    aws_api_gateway_model.this,
    aws_api_gateway_resource.root_level,
    aws_api_gateway_resource.first_child_level,
    aws_api_gateway_resource.second_child_level,
    aws_api_gateway_resource.third_child_level,
    aws_api_gateway_resource.fourth_child_level,
    aws_api_gateway_resource.fifth_child_level,
    aws_api_gateway_resource.sixth_child_level,
    aws_api_gateway_authorizer.this
  ]
}
