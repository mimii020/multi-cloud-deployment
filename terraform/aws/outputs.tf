output "cluster_name" {
  description = "EKS cluster name"
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value = module.eks.cluster_endpoint
}

output "region" {
  description = "AWS region"
  value = var.aws_region
}

output "vpc_id" {
  description = "VPC ID"
  value = module.vpc.vpc_id
}

output "backend_s3_bucket" {
  description = "Backend S3 bucket"
  value = aws_s3_bucket.backend.bucket
}