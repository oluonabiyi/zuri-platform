terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.0" }
  }
  backend "s3" {
    bucket       = "zuri-tfstate-olumide-2026"
    key          = "zuri/dev/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true # S3-native state locking, no DynamoDB table needed
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = { Project = "zuri-market", Environment = var.environment, ManagedBy = "terraform" }
  }
}
