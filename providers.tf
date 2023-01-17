terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}


provider "aws" {
  region                   = "us-east-2"
  shared_config_files      = ["C:/Users/Tyler Hatfield/.aws/config"]
  shared_credentials_files = ["C:/Users/Tyler Hatfield/.aws/credentials"]
  profile                  = "vscode"
}
