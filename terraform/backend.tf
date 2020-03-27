terraform {
  backend "s3" {
    bucket = "moonpay-signer-tf-dev"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}



