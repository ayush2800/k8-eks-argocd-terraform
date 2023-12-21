data "aws_caller_identity" "current" {}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "ekstest-ayushmsh"
    key    = "k8-demo-vpc.tfstate"
    region = "us-west-2"
  }
}
