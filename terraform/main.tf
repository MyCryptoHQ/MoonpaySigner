module "api-gateway-lambda" {
  environment = "prod"
  source      = "./modules/api-gateway-lambda"
  filename    = "../moonpaysigner.zip"
  endpoint    = var.endpoint
}