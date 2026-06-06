terraform {
  backend "s3" {
    bucket         = "pipeline-terraform-ansible-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}