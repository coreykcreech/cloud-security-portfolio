terraform {
  required_version = ">= 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "corey-portfolio-tf-state-608942062049"
    key          = "project-01-vpc/terraform.tfstate"
    region       = "us-east-1"
    profile      = "terraform"
    use_lockfile = true
    encrypt      = true
  }
}
