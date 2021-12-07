variable "stage" {
  description = "The name of the stage."
  type        = string
}

variable "project" {
  description = "Project name."
  type        = string
}

variable "models" {
  description = "List of API Gateway models to create. Models can be used for request and response."
  type = list(object({
    content_type = string
    name         = string
    description  = string
    schema       = string
  }))
}

variable "api_gateway_root_paths" {
  description = "List paths on the API Gateway root level (/)."
  type = list(object({
    path_part          = string
    request_parameters = any
  }))
}

variable "enable_cors" {
  description = "Enables CORS for all resources."
  type        = bool
  default     = false
}

variable "stage_name" {
  description = "The name of the API Gateway stage."
  type        = string
  default     = "v1"
}

variable "api_gateway_first_child_paths" {
  description = "List paths on the API Gateway child level after a root level (e.g. /myroot/{path_part}). parent_path_index must be a index in the api_gateway_root_paths list."
  type = list(object({
    path_part          = string
    parent_path_index  = number
    request_parameters = any
  }))
  default = []
}

variable "api_gateway_second_child_paths" {
  description = "List paths on the API Gateway child level after the first level. parent_path_index must be a index in the api_gateway_first_paths list."
  type = list(object({
    path_part          = string
    parent_path_index  = number
    request_parameters = any
  }))
  default = []
}

variable "api_gateway_third_child_paths" {
  description = "List paths on the API Gateway child level after the second level. parent_path_index must be a index in the api_gateway_second_paths list."
  type = list(object({
    path_part          = string
    parent_path_index  = number
    request_parameters = any
  }))
  default = []
}

variable "api_gateway_fourth_child_paths" {
  description = "List paths on the API Gateway child level after the third level. parent_path_index must be a index in the api_gateway_third_paths list."
  type = list(object({
    path_part          = string
    parent_path_index  = number
    request_parameters = any
  }))
  default = []
}

variable "api_gateway_fifth_child_paths" {
  description = "List paths on the API Gateway child level after the fourth level. parent_path_index must be a index in the api_gateway_fourth_paths list."
  type = list(object({
    path_part          = string
    parent_path_index  = number
    request_parameters = any
  }))
  default = []
}

variable "api_gateway_sixth_child_paths" {
  description = "List paths on the API Gateway child level after the fifth level. parent_path_index must be a index in the api_gateway_fifth_paths list."
  type = list(object({
    path_part          = string
    parent_path_index  = number
    request_parameters = any
  }))
  default = []
}

variable "cognito_user_pool_arn" {
  description = "Cognito user pool ARN used for authentication. If set to null no authenticator will be created."
  type        = string
  default     = null
}

variable "validate_request_body" {
  description = "Validate the request bodies for all methods."
  type        = bool
  default     = true
}

variable "validate_request_parameters" {
  description = "Validate the request parameters for all methods."
  type        = bool
  default     = true
}

variable "log_retention_in_days" {
  description = "Time in day to preserve the API logs."
  type        = number
  default     = 7
}

variable "xray_tracing_enabled" {
  description = "Whether active tracing with X-ray is enabled."
  type        = bool
  default     = false
}

variable "enable_metrics" {
  description = "Enable metric logging."
  type        = bool
  default     = false
}

variable "logging_level" {
  description = "Logging level."
  type        = string
  default     = "INFO"
}

variable "data_trace_enabled" {
  description = "Enable full request/response logging."
  type        = bool
  default     = false
}

variable "lambda_functions" {
  description = "List of Lambda function to add to the REST API Gateway with proxy integration. child_path_index must be a index in api_gateway_child_paths or -1 if not applied. root_path_index must be a index in api_gateway_root_paths or -1 if not applied. child_path_index and root_path_index can never be both > 0."
  type = list(object({
    path_level         = number
    path_index         = number
    http_method        = string
    authorization      = string
    request_parameters = map(string)
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
  }))
}

variable "mock_functions" {
  description = "List of Mock functions to add to the REST API Gateway."
  type = list(object({
    path_level         = number
    path_index         = number
    http_method        = string
    authorization      = string
    request_parameters = map(string)
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
  }))
}

locals {
  prefix_env = terraform.workspace == "default" ? var.stage : terraform.workspace
  prefix     = "${var.project}-${local.prefix_env}"
  name       = "${local.prefix}-rest-api"
  default_tags = {
    stage        = var.stage
    project      = var.project
    tf_workspace = terraform.workspace
  }
  path_list = [
    aws_api_gateway_resource.root_level,
    aws_api_gateway_resource.first_child_level,
    aws_api_gateway_resource.second_child_level,
    aws_api_gateway_resource.third_child_level,
    aws_api_gateway_resource.fourth_child_level,
    aws_api_gateway_resource.fifth_child_level,
    aws_api_gateway_resource.sixth_child_level
  ]
}
