variable "profile" {
  description = ""
  default     = ""
}

variable "region" {
  description = ""
  default     = "us-east-1"
}

variable "endpoint" {
  type        = string
  description = "Name of api endpoint."
  default     = "moonpay.mycryptoapi.com"
}

variable "moonpay_secret_key" {
  description = ""
  default     = ""
}