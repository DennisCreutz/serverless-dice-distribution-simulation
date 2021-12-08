terraform {
  backend "s3" {
    bucket         = "serverless-dds-dev-remote-backend"
    region         = "eu-central-1"
    dynamodb_table = "serverless-dds-dev-remote-backend-db"
    key            = "live/serverless-dds/dev/api/terraform.tfstate"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-central-1"
}

data "terraform_remote_state" "lambda_dice_roller" {
  backend = "s3"

  config = {
    bucket = "serverless-dds-dev-remote-backend"
    key    = "live/serverless-dds/dev/lambda/dice-roller/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "lambda_get_results" {
  backend = "s3"

  config = {
    bucket = "serverless-dds-dev-remote-backend"
    key    = "live/serverless-dds/dev/lambda/get-results/terraform.tfstate"
    region = "eu-central-1"
  }
}


resource "aws_api_gateway_rest_api" "this" {
  name = "${local.prefix}-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

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
    aws_api_gateway_resource.root_level,
    aws_api_gateway_integration.get,
    aws_api_gateway_integration_response.get_http_200,
    aws_api_gateway_method.get,
    aws_api_gateway_method_response.get_http_200,
    aws_lambda_permission.get,
    aws_api_gateway_integration.post,
    aws_api_gateway_integration_response.post_http_200,
    aws_api_gateway_method.post,
    aws_api_gateway_method_response.post_http_200,
    aws_lambda_permission.post
  ]
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "v1"

  # Need to set this or else Terraform always want to remove the value (cache_cluster is still not enabled)
  cache_cluster_size = 0.5

  tags = local.default_tags
}

resource "aws_api_gateway_resource" "root_level" {
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "dice"
  rest_api_id = aws_api_gateway_rest_api.this.id
}
