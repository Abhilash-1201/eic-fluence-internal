terraform {
  backend "s3" {
    bucket = "demo-fluence-terraform"
    key = "fluence/terraform.tfstate"
    region = "us-east-2" #ohio
    dynamodb_table = "demo-fluence-state-locking"
    
  }
}
