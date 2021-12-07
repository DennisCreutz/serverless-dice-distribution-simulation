variable "rest_api_lambda_function" {
  description = "Lambda function to add to the REST API Gateway with proxy integration."
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
      content_type      = string
      model_name        = string
      method_parameters = any
    })
    lambda_invoke_arn    = string
    lambda_function_name = string
    lambda_alias_name    = string
    enable_cors          = bool
    validator_id         = string
  })
}

locals {
  method_response_parameters = var.rest_api_lambda_function.enable_cors == true ? merge(
    { "method.response.header.Access-Control-Allow-Origin" = false }, var.rest_api_lambda_function.response_model_200.method_parameters
  ) : var.rest_api_lambda_function.response_model_200.method_parameters
}
