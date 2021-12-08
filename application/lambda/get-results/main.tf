terraform {
  backend "s3" {
    bucket         = "serverless-dds-dev-remote-backend"
    region         = "eu-central-1"
    dynamodb_table = "serverless-dds-dev-remote-backend-db"
    key            = "live/serverless-dds/dev/lambda/get-results/terraform.tfstate"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-central-1"
}

data "terraform_remote_state" "dynamodb" {
  backend = "s3"

  config = {
    bucket = "serverless-dds-dev-remote-backend"
    key    = "live/serverless-dds/dev/dynamodb/terraform.tfstate"
    region = "eu-central-1"
  }
}

module "lambda_get_results" {
  source = "../../../modules/lambda"

  stage   = local.stage
  project = local.project

  lambda_name = "get-results"

  source_dir = "./app"

  timeout     = 10
  memory_size = 128

  environment_variables = [{
    variables = {
      "DYNAMO_DB_NAME" : data.terraform_remote_state.dynamodb.outputs.name
    }
  }]

  additional_lambda_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:Query"
      ],
      "Resource": "${data.terraform_remote_state.dynamodb.outputs.arn}",
      "Effect": "Allow"
    }
  ]
}
EOF
}
