resource "aws_apigatewayv2_api" "workmotion_api" {
  name          = "workmotion_api"
  protocol_type = "HTTP"
}