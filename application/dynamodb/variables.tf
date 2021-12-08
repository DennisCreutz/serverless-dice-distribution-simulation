locals {
  stage               = "dev"
  project             = "serverless-dds"
  prefix_env          = terraform.workspace == "default" ? local.stage : terraform.workspace
  prefix              = "${local.project}-${local.prefix_env}"

  default_tags = {
    stage        = local.stage
    project      = local.project
    tf_workspace = terraform.workspace
  }
}
