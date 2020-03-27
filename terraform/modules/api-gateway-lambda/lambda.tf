resource "aws_lambda_function" "moonpay-signer" {
  filename      = var.filename
  function_name = "moonpay-signer-lambda-${var.environment}"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "bin/moonpaysigner"
  timeout       = 600

  source_code_hash = filebase64sha256(var.filename)

  runtime = "go1.x"

  environment {
    variables = {
      MOONPAY_SECRET_KEY = var.moonpay_secret_key
    }
  }
}


resource "aws_iam_role" "lambda_exec" {
  name = "moonpay-signer-${var.environment}-role"

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


resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.moonpay-signer.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.moonpay_api_gateway.execution_arn}/*/*"

  depends_on = [
    aws_api_gateway_rest_api.moonpay_api_gateway
  ]
}

resource "aws_api_gateway_rest_api" "moonpay_api_gateway" {
  name        = "MoonpaySigner"
  description = "The signer REST API"
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_method" "request_method" {
  rest_api_id   = aws_api_gateway_rest_api.moonpay_api_gateway.id
  resource_id   = aws_api_gateway_rest_api.moonpay_api_gateway.root_resource_id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "request_method_integration" {
  rest_api_id = aws_api_gateway_rest_api.moonpay_api_gateway.id
  resource_id = aws_api_gateway_method.request_method.resource_id
  http_method = aws_api_gateway_method.request_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.moonpay-signer.invoke_arn

  depends_on = [aws_lambda_function.moonpay-signer]
}

//resource "aws_api_gateway_integration_response" "integration_response" {
//  rest_api_id = aws_api_gateway_rest_api.moonpay_api_gateway.id
//  resource_id = aws_api_gateway_resource.gateway_resource.id
//  http_method = aws_api_gateway_method.request_method.http_method
//  status_code = 200
//  depends_on  = ["aws_api_gateway_integration.request_method_integration"]
//
//  response_models = {
//    "application/json" = "Empty"
//  }
//}

resource "aws_api_gateway_deployment" "moonpay_v1" {
  depends_on = [
		aws_api_gateway_integration.options_integration,
    aws_api_gateway_integration.request_method_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.moonpay_api_gateway.id
  stage_name  = var.environment
}

resource "aws_api_gateway_base_path_mapping" "moonpayDev" {
  api_id      = aws_api_gateway_rest_api.moonpay_api_gateway.id
  stage_name  = aws_api_gateway_deployment.moonpay_v1.stage_name
  domain_name = var.endpoint
}