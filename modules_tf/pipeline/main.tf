resource "aws_codecommit_repository" "endpoint_repo" {
  repository_name = var.project_name
  description     = "${var.project_name} repository."
}

resource "aws_s3_bucket" "endpoint_build_artifact_bucket" {
  bucket        = "${var.project_name}-artifacts"
  acl           = "private"
}

resource "aws_kms_key" "endpoint_artifact_encryption_key" {
  description             = "${var.project_name}-artifact-encryption-key"
}

resource "aws_ecr_repository" "endpoint_ecr" {
  name                 = var.project_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

