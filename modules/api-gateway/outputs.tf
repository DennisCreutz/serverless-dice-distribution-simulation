output "execution_arn" {
  value = aws_api_gateway_rest_api.this.execution_arn
}

output "stage_arn" {
  value = aws_api_gateway_stage.this.arn
}

output "stage" {
  value = aws_api_gateway_stage.this.stage_name
}

output "api_name" {
  value = local.name
}