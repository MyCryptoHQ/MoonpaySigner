terraform {
  backend "s3" {
    bucket = "moonpay-tf-prod"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}



