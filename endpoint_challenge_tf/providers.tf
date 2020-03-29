/*
* I would normally use s3 with versioning to use as a backend, but
* I didn't think it was appropriate for this excercise.
terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}
*/

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}


