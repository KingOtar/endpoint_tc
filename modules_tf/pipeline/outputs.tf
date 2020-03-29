output "clone_url_http" {
	value = aws_codecommit_repository.endpoint_repo.clone_url_http
}

output "repository_url" {
	value = aws_ecr_repository.endpoint_ecr.repository_url
}
