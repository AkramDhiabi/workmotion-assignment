output "function_name" {
  description = "Name of the Lambda function."
  value       = aws_lambda_function.workmotion_lambda.function_name
}

output "deployment_invoke_url" {
  description = "Deployment invoke url"
  value       = aws_api_gateway_deployment.workmotion_dev.invoke_url
}