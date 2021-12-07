##########################################################################################################
#### A path got a dependency to his parent path. For this reason we must work with multiple resources ####
##########################################################################################################

resource "aws_api_gateway_resource" "root_level" {
  count = length(var.api_gateway_root_paths)

  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = var.api_gateway_root_paths[count.index].path_part
  rest_api_id = aws_api_gateway_rest_api.this.id
}
module "root_cors" {
  count = var.enable_cors ? length(var.api_gateway_root_paths) : 0

  source = "./cors"

  api      = aws_api_gateway_rest_api.this.id
  resource = aws_api_gateway_resource.root_level[count.index].id

  methods = ["GET", "POST", "PUT", "DELETE"]
  headers = ["Content-Type", "X-Amz-Date", "Authorization", "X-Api-Key", "X-Amz-Security-Token", "X-Amz-Access-Token", "X-Amz-Id-Token"]

  request_parameters = var.api_gateway_root_paths[count.index].request_parameters
}

resource "aws_api_gateway_resource" "first_child_level" {
  count = length(var.api_gateway_first_child_paths)

  parent_id   = aws_api_gateway_resource.root_level[var.api_gateway_first_child_paths[count.index].parent_path_index].id
  path_part   = var.api_gateway_first_child_paths[count.index].path_part
  rest_api_id = aws_api_gateway_rest_api.this.id

  depends_on = [aws_api_gateway_resource.root_level]
}
module "first_child_cors" {
  count = var.enable_cors ? length(var.api_gateway_first_child_paths) : 0

  source = "./cors"

  api      = aws_api_gateway_rest_api.this.id
  resource = aws_api_gateway_resource.first_child_level[count.index].id

  methods = ["GET", "POST", "PUT", "DELETE"]
  headers = ["Content-Type", "X-Amz-Date", "Authorization", "X-Api-Key", "X-Amz-Security-Token", "X-Amz-Access-Token", "X-Amz-Id-Token"]

  request_parameters = var.api_gateway_first_child_paths[count.index].request_parameters
}

resource "aws_api_gateway_resource" "second_child_level" {
  count = length(var.api_gateway_second_child_paths)

  parent_id   = aws_api_gateway_resource.first_child_level[var.api_gateway_second_child_paths[count.index].parent_path_index].id
  path_part   = var.api_gateway_second_child_paths[count.index].path_part
  rest_api_id = aws_api_gateway_rest_api.this.id

  depends_on = [aws_api_gateway_resource.first_child_level]
}
module "second_child_cors" {
  count = var.enable_cors ? length(var.api_gateway_second_child_paths) : 0

  source = "./cors"

  api      = aws_api_gateway_rest_api.this.id
  resource = aws_api_gateway_resource.second_child_level[count.index].id

  methods = ["GET", "POST", "PUT", "DELETE"]
  headers = ["Content-Type", "X-Amz-Date", "Authorization", "X-Api-Key", "X-Amz-Security-Token", "X-Amz-Access-Token", "X-Amz-Id-Token"]

  request_parameters = var.api_gateway_second_child_paths[count.index].request_parameters
}

resource "aws_api_gateway_resource" "third_child_level" {
  count = length(var.api_gateway_third_child_paths)

  parent_id   = aws_api_gateway_resource.second_child_level[var.api_gateway_third_child_paths[count.index].parent_path_index].id
  path_part   = var.api_gateway_third_child_paths[count.index].path_part
  rest_api_id = aws_api_gateway_rest_api.this.id

  depends_on = [aws_api_gateway_resource.second_child_level]
}
module "third_child_cors" {
  count = var.enable_cors ? length(var.api_gateway_third_child_paths) : 0

  source = "./cors"

  api      = aws_api_gateway_rest_api.this.id
  resource = aws_api_gateway_resource.third_child_level[count.index].id

  methods = ["GET", "POST", "PUT", "DELETE"]
  headers = ["Content-Type", "X-Amz-Date", "Authorization", "X-Api-Key", "X-Amz-Security-Token", "X-Amz-Access-Token", "X-Amz-Id-Token"]

  request_parameters = var.api_gateway_third_child_paths[count.index].request_parameters
}

resource "aws_api_gateway_resource" "fourth_child_level" {
  count = length(var.api_gateway_fourth_child_paths)

  parent_id   = aws_api_gateway_resource.third_child_level[var.api_gateway_fourth_child_paths[count.index].parent_path_index].id
  path_part   = var.api_gateway_fourth_child_paths[count.index].path_part
  rest_api_id = aws_api_gateway_rest_api.this.id

  depends_on = [aws_api_gateway_resource.third_child_level]
}
module "fourth_child_cors" {
  count = var.enable_cors ? length(var.api_gateway_fourth_child_paths) : 0

  source = "./cors"

  api      = aws_api_gateway_rest_api.this.id
  resource = aws_api_gateway_resource.fourth_child_level[count.index].id

  methods = ["GET", "POST", "PUT", "DELETE"]
  headers = ["Content-Type", "X-Amz-Date", "Authorization", "X-Api-Key", "X-Amz-Security-Token", "X-Amz-Access-Token", "X-Amz-Id-Token"]

  request_parameters = var.api_gateway_fourth_child_paths[count.index].request_parameters
}

resource "aws_api_gateway_resource" "fifth_child_level" {
  count = length(var.api_gateway_fifth_child_paths)

  parent_id   = aws_api_gateway_resource.fourth_child_level[var.api_gateway_fifth_child_paths[count.index].parent_path_index].id
  path_part   = var.api_gateway_fifth_child_paths[count.index].path_part
  rest_api_id = aws_api_gateway_rest_api.this.id

  depends_on = [aws_api_gateway_resource.fourth_child_level]
}
module "fifth_child_cors" {
  count = var.enable_cors ? length(var.api_gateway_fifth_child_paths) : 0

  source = "./cors"

  api      = aws_api_gateway_rest_api.this.id
  resource = aws_api_gateway_resource.fifth_child_level[count.index].id

  methods = ["GET", "POST", "PUT", "DELETE"]
  headers = ["Content-Type", "X-Amz-Date", "Authorization", "X-Api-Key", "X-Amz-Security-Token", "X-Amz-Access-Token", "X-Amz-Id-Token"]

  request_parameters = var.api_gateway_fifth_child_paths[count.index].request_parameters
}

resource "aws_api_gateway_resource" "sixth_child_level" {
  count = length(var.api_gateway_sixth_child_paths)

  parent_id   = aws_api_gateway_resource.fifth_child_level[var.api_gateway_sixth_child_paths[count.index].parent_path_index].id
  path_part   = var.api_gateway_sixth_child_paths[count.index].path_part
  rest_api_id = aws_api_gateway_rest_api.this.id

  depends_on = [aws_api_gateway_resource.fifth_child_level]
}
module "sixth_child_cors" {
  count = var.enable_cors ? length(var.api_gateway_sixth_child_paths) : 0

  source = "./cors"

  api      = aws_api_gateway_rest_api.this.id
  resource = aws_api_gateway_resource.sixth_child_level[count.index].id

  methods = ["GET", "POST", "PUT", "DELETE"]
  headers = ["Content-Type", "X-Amz-Date", "Authorization", "X-Api-Key", "X-Amz-Security-Token", "X-Amz-Access-Token", "X-Amz-Id-Token"]

  request_parameters = var.api_gateway_sixth_child_paths[count.index].request_parameters
}
