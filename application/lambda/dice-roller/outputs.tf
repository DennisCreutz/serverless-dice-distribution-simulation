output "function_name" {
  value = module.lambda_dice_roller.lambda_function.function_name
}

output "invoke_arn" {
  value = module.lambda_dice_roller.lambda_function.invoke_arn
}
