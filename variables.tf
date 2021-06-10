variable "test_case" {
  default = "1"
  type    = string
}

variable "region" {
  default = "eu-west-2"
  type    = string
}

variable "additional_tags" {
  default     = {
    Svc      = "AWS Network Firewall (anfw) Testing"
    SvcOwner = "OllieJC"
    SvcLink  = "https://github.com/OllieJC/aws-network-firewall-testing"
  }
  description = "Additional resource tags"
  type        = map(string)
}

variable "allowed_https_domains" {
  default = []
  type    = list
}
