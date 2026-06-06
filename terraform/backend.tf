terraform {
  backend "s3" {
    bucket         = "pipeline-terraform-ansible-state-dsf"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-dsf"
    encrypt        = true
  }
}