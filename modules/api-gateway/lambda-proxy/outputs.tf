output "api_gateway_deploy_trigger" {
  value = concat(aws_api_gateway_method.this.*.id, aws_api_gateway_integration.this.*.id, aws_api_gateway_integration_response.http_200.*.id, aws_api_gateway_method_response.http_200.*.id)
}
