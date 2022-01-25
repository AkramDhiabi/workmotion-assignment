resource "aws_api_gateway_rest_api" "workmotion_apigw" {
  name = "workmotion_apigw"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
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

# GET method integration
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
  type                    = "AWS"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  uri                     = aws_lambda_function.workmotion_lambda.invoke_arn
  request_templates = { # Not documented
    "application/json" = "${file("./lambda-payload/workmotion_body_mapping.tpl")}"
  }
}

resource "aws_api_gateway_method_response" "get_200" {
  rest_api_id = aws_api_gateway_rest_api.workmotion_apigw.id
  resource_id = aws_api_gateway_resource.workmotion_api.id
  http_method = aws_api_gateway_method.workmotion_get.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "get_200" {
  depends_on = [
    aws_api_gateway_integration.workmotion_get
  ]
  rest_api_id = aws_api_gateway_rest_api.workmotion_apigw.id
  resource_id = aws_api_gateway_resource.workmotion_api.id
  http_method = aws_api_gateway_method.workmotion_get.http_method
  status_code = aws_api_gateway_method_response.get_200.status_code
}

# POST method integration
resource "aws_api_gateway_method" "workmotion_post" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.workmotion_api.id
  rest_api_id   = aws_api_gateway_rest_api.workmotion_apigw.id
}

resource "aws_api_gateway_integration" "workmotion_post" {
  rest_api_id             = aws_api_gateway_rest_api.workmotion_apigw.id
  resource_id             = aws_api_gateway_resource.workmotion_api.id
  http_method             = aws_api_gateway_method.workmotion_post.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  uri                     = aws_lambda_function.workmotion_lambda.invoke_arn
  request_templates = { # Not documented
    "application/json" = "${file("./lambda-payload/workmotion_body_mapping.tpl")}"
  }
}

resource "aws_api_gateway_method_response" "post_200" {
  rest_api_id = aws_api_gateway_rest_api.workmotion_apigw.id
  resource_id = aws_api_gateway_resource.workmotion_api.id
  http_method = aws_api_gateway_method.workmotion_post.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "post_200" {
  depends_on = [
    aws_api_gateway_integration.workmotion_post
  ]
  rest_api_id = aws_api_gateway_rest_api.workmotion_apigw.id
  resource_id = aws_api_gateway_resource.workmotion_api.id
  http_method = aws_api_gateway_method.workmotion_post.http_method
  status_code = aws_api_gateway_method_response.post_200.status_code
}

# Api Gateway deployment
resource "aws_api_gateway_deployment" "workmotion_dev" {
  depends_on = [
    aws_api_gateway_integration.workmotion_get, aws_api_gateway_integration.workmotion_post
  ]
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.workmotion_api.id,
      aws_api_gateway_method.workmotion_get.id,
      aws_api_gateway_method.workmotion_post.id,
      aws_api_gateway_integration.workmotion_get.id,
      aws_api_gateway_integration.workmotion_post.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
  rest_api_id = aws_api_gateway_rest_api.workmotion_apigw.id
}

resource "aws_api_gateway_stage" "workmotion_dev" {
  deployment_id = aws_api_gateway_deployment.workmotion_dev.id
  rest_api_id   = aws_api_gateway_rest_api.workmotion_apigw.id
  stage_name    = "dev"
}