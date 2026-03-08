terraform {
  backend "s3" {
    bucket       = "aws-project-using-terraform-state-file-bucket"
    key          = "StateFile/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}