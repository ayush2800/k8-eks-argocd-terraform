terraform {
  backend "s3" {
    bucket = "ekstest-ayushmsh"
    key    = "k8-demo-argocd.tfstate"
    region = "us-west-2"
  }
}