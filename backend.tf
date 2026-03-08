terraform {
  backend "s3" {
    bucket       = "Name_Of_your_AWS_S3_Bucket"
    key          = "Directory/terraform.tfstate"
    region       = "AWS_Region"
    use_lockfile = true #State Lock
  }
}
