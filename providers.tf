terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}


provider "aws" {
  region = "${var.region}"
  #shared_config_files      = ["C:/Users/Tyler Hatfield/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "vscode"
}
