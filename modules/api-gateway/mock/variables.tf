variable "mock_function" {
  description = "Mock function to add to the REST API Gateway."
  type = object({
    rest_api_id            = string
    rest_api_execution_arn = string
    resource_id            = string
    http_method            = string
    authorization          = string
    authorizer_id          = string
    request_parameters     = map(string)
    request_model = object({
      content_type = string
      model_name   = string
    })
    response_model_200 = object({
      content_type           = string
      model_name             = string
      integration_parameters = any
      method_parameters      = any
    })
    mock_response      = string
    mock_response_type = string
    enable_cors        = bool
    validator_id       = string
  })
}

locals {
  integration_response_parameters = var.mock_function.enable_cors == true ? merge(
    { "method.response.header.Access-Control-Allow-Origin" = "'*'" }, var.mock_function.response_model_200.integration_parameters
  ) : var.mock_function.response_model_200.integration_parameters
  method_response_parameters = var.mock_function.enable_cors == true ? merge(
    { "method.response.header.Access-Control-Allow-Origin" = false }, var.mock_function.response_model_200.method_parameters
  ) : var.mock_function.response_model_200.method_parameters
}
