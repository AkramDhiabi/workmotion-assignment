output "function_name" {
  description = "Name of the Lambda function."
  value       = aws_lambda_function.workmotion_lambda.function_name
}

output "deployment_invoke_url" {
  description = "Deployment invoke url"
  value       = "${aws_api_gateway_stage.workmotion_stage.invoke_url}/${trimprefix("${aws_api_gateway_resource.workmotion_api.path}", "/")}"
}