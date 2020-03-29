resource "aws_codepipeline" "codepipeline" {
  name     = var.project_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store  {
    location = aws_s3_bucket.endpoint_build_artifact_bucket.bucket
    type     = "S3"

    encryption_key  {
      id   = aws_kms_key.endpoint_artifact_encryption_key.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        RepositoryName = "${var.project_name}"
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "Package"

    action {
      name             = "Package"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      output_artifacts = ["packaged"]
      version          = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.build_project.name}"
      }
    }
  }
}
