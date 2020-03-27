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

data "aws_route53_zone" "mycryptoapi_hosted_zone" {
  name         = "mycryptoapi.com."
  private_zone = false
}

resource "aws_api_gateway_domain_name" "moonpay" {
  domain_name     = var.endpoint
  certificate_arn = aws_acm_certificate_validation.moonpay_acm_validation.certificate_arn
}

# Example DNS record using Route53.
# Route53 is not specifically required; any DNS host can be used.
resource "aws_route53_record" "moonpay" {
  name    = aws_api_gateway_domain_name.moonpay.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.mycryptoapi_hosted_zone.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_api_gateway_domain_name.moonpay.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.moonpay.cloudfront_zone_id
  }
}