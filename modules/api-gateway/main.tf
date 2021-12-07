terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = "~> 3.68"
  }
}

resource "aws_api_gateway_rest_api" "this" {
  name = local.name

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  binary_media_types = ["multipart/form-data"]

  tags = local.default_tags
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_cloudwatch_log_group.this,
    aws_api_gateway_model.this,
    module.mocks,
    module.lambdas,
    module.root_cors,
    module.first_child_cors,
    module.second_child_cors,
    module.third_child_cors,
    module.fourth_child_cors,
    module.fifth_child_cors,
    module.sixth_child_cors
  ]
}

resource "aws_api_gateway_request_validator" "this" {
  name                        = "validator"
  rest_api_id                 = aws_api_gateway_rest_api.this.id
  validate_request_body       = var.validate_request_body
  validate_request_parameters = var.validate_request_parameters
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.stage_name

  # Need to set this or else Terraform always want to remove the value (cache_cluster is still not enabled)
  cache_cluster_size = 0.5

  xray_tracing_enabled = var.xray_tracing_enabled

  tags = local.default_tags

  depends_on = [
    aws_cloudwatch_log_group.this,
    aws_api_gateway_model.this,
    module.mocks,
    module.lambdas,
    module.root_cors,
    module.first_child_cors,
    module.second_child_cors,
    module.third_child_cors,
    module.fourth_child_cors,
    module.fifth_child_cors,
    module.sixth_child_cors
  ]
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled    = var.enable_metrics
    logging_level      = var.logging_level
    data_trace_enabled = var.data_trace_enabled
  }

  depends_on = [aws_api_gateway_account.global]
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.this.id}/${var.stage_name}"
  retention_in_days = var.log_retention_in_days

  depends_on = [aws_api_gateway_account.global]
}

resource "aws_api_gateway_model" "this" {
  count = length(var.models)

  content_type = var.models[count.index].content_type
  name         = var.models[count.index].name
  rest_api_id  = aws_api_gateway_rest_api.this.id

  description = var.models[count.index].description
  schema      = var.models[count.index].schema
}

resource "aws_api_gateway_authorizer" "this" {
  count = var.cognito_user_pool_arn == null ? 0 : 1

  name          = "${local.prefix}-cognito-auth"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.this.id
  provider_arns = [var.cognito_user_pool_arn]
}
