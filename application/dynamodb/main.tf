terraform {
  backend "s3" {
    bucket         = "serverless-dds-dev-remote-backend"
    region         = "eu-central-1"
    dynamodb_table = "serverless-dds-dev-remote-backend-db"
    key            = "live/serverless-dds/dev/dynamodb/terraform.tfstate"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_dynamodb_table" "dice_rolls" {
  name           = "${local.prefix}-dice-rolls"

  hash_key       = "Die-Sides"
  range_key      = "Sum-RollInstanceID"

  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "Die-Sides"
    type = "S"
  }

  attribute {
    name = "Sum-RollInstanceID"
    type = "S"
  }

  tags = local.default_tags
}
