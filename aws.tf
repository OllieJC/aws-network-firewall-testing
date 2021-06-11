terraform {
  required_providers {
    aws = {
      version = ">= 3.28.0"
      source  = "hashicorp/aws"

      default_tags = {
        Svc      = "anfw - AWS Network Firewall Testing"
        SvcOwner = "OllieJC"
        SvcLink  = "https://github.com/OllieJC/aws-network-firewall-testing"
      }
    }
    random = {
      source  = "hashicorp/random"
      version = ">=2.3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}
