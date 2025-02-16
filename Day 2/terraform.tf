terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-v5"
    key            = "terraform/state.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}