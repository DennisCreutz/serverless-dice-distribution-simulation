output "function_name" {
  value = module.lambda_get_results.lambda_function.function_name
}

output "invoke_arn" {
  value = module.lambda_get_results.lambda_function.invoke_arn
}
