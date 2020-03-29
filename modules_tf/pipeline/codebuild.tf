resource "aws_codebuild_project" "build_project" {
  name           = "${var.project_name}-package"
  description    = "Codebuild ${var.project_name}"
  service_role   = aws_iam_role.codebuild_assume_role.arn
	#build_timeout  = "${var.build_timeout}"
  encryption_key = aws_kms_key.endpoint_artifact_encryption_key.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
    type         = "LINUX_CONTAINER"
		privileged_mode = true
  }

  source {
    type      = "CODEPIPELINE"
		#buildspec = "${var.package_buildspec}"
  }
}
