output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "backend_s3_bucket" {
  description = "Backend S3 bucket"
  value       = aws_s3_bucket.backend.bucket
}