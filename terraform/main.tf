module "api-gateway-lambda" {
  environment = "dev"
  source = "./modules/api-gateway-lambda"
  filename = "../moonpaysigner.zip"
}