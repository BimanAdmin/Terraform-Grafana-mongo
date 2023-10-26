provider "aws" {
  region = "us-east-2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "kubernetes" {
    //config_context_cluter = "demo"
     config_path = "!/.kube/config"
}



