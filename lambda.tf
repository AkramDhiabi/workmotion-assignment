data "archive_file" "zipit" {
  type        = "zip"
  source_file = "${path.module}/lambda-payload/index.js"
  output_path = "${path.module}/workmotion-lambda.zip"
}

resource "aws_lambda_function" "workmotion_lambda" {
  depends_on       = [data.archive_file.zipit]
  filename         = "${path.module}/workmotion-lambda.zip"
  function_name    = "printEvents"
  handler          = "index.handler"
  source_code_hash = data.archive_file.zipit.output_base64sha256
  runtime          = "nodejs14.x"
  role             = aws_iam_role.workmotion_lambda.arn

  tags = local.common_tags
}

# Lambda workmotion_lambda IAM role and attached policies
resource "aws_iam_role" "workmotion_lambda" {
  name = "workmotion_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}