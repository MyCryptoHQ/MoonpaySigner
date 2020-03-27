module "api-gateway-lambda" {
  environment        = "prod"
  source             = "./modules/api-gateway-lambda"
  filename           = "../moonpaysigner.zip"
  endpoint           = var.endpoint
  moonpay_secret_key = var.moonpay_secret_key
}