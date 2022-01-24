resource "aws_api_gateway_rest_api" "workmotion_apigw" {
  name          = "workmotion_apigw"
}

resource "aws_cloudwatch_log_group" "workmotion_api" {
  name = "/aws/api_gw/${aws_api_gateway_rest_api.workmotion_apigw.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "apigw_workmotion_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.workmotion_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.workmotion_apigw.execution_arn}/*/*"
}

resource "aws_api_gateway_resource" "workmotion_api" {
  parent_id   = aws_api_gateway_rest_api.workmotion_apigw.root_resource_id
  path_part   = "api"
  rest_api_id = aws_api_gateway_rest_api.workmotion_apigw.id
}

resource "aws_api_gateway_method" "workmotion_get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.workmotion_api.id
  rest_api_id   = aws_api_gateway_rest_api.workmotion_apigw.id
}

resource "aws_api_gateway_integration" "workmotion_get" {
  rest_api_id             = aws_api_gateway_rest_api.workmotion_apigw.id
  resource_id             = aws_api_gateway_resource.workmotion_api.id
  http_method             = aws_api_gateway_method.workmotion_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.workmotion_lambda.invoke_arn
  request_templates = {                  # Not documented
    "application/json" = "${file("./lambda-payload/workmotion_body_mapping.tpl")}"
  }
}