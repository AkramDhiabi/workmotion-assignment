output "function_name" {
  description = "Name of the Lambda function."
  value = aws_lambda_function.workmotion_lambda.function_name
}

output "base_url" {
  description = "Base URL for API Gateway stage."
  value = aws_api_gateway_rest_api.workmotion_apigw.invoke_url
}