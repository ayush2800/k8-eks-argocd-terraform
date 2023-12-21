terraform {
  backend "s3" {
    bucket = "ekstest-ayushmsh"
    key    = "k8-demo-vpc.tfstate"
    region = "us-west-2"
  }
}