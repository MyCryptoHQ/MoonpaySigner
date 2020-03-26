resource "aws_acm_certificate" "moonpay_acm" {
  domain_name       = var.endpoint
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "moonpay_acm_validation" {
  certificate_arn = aws_acm_certificate.moonpay_acm.arn
}

locals {
  custom_origin_id = "customOrigin"
}