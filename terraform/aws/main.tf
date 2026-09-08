terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_eks_cluster" "main" {
  name     = "${var.project_name}-${var.environment}-eks"
  role_arn = "arn:aws:iam::975050333241:role/eksClusterRole"
  version  = "1.30"

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = [var.security_group_id]
    endpoint_public_access  = true
    endpoint_private_access = true
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-eks"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "default-node-group"
  node_role_arn   = "arn:aws:iam::975050333241:role/AmazonEKSNodeRole"
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  tags = {
    Name        = "${var.project_name}-${var.environment}-node"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  depends_on = [aws_eks_cluster.main]
}

resource "aws_s3_bucket" "backend" {
  bucket_prefix = "${var.project_name}-backend-"
  tags = {
    Name = "${var.project_name}-backend"
  }
}

resource "aws_s3_bucket_public_access_block" "backend" {
  bucket = aws_s3_bucket.backend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "backend_config" {
  bucket        = aws_s3_bucket.backend.id
  key           = "config.json"
  source        = "${path.module}/config.json"
  content_type  = "application/json"
}

resource "aws_iam_policy" "backend_s3" {
  name        = "${var.project_name}-backend-s3-policy"
  description = "Allows backend pods to read configuration from S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = ["${aws_s3_bucket.backend.arn}/*"]
      }
    ]
  })
}

resource "aws_iam_role" "backend_pod" {
  name = "${var.project_name}-backend-pod-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = ["sts:AssumeRole", "sts:TagSession"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backend_s3" {
  role       = aws_iam_role.backend_pod.name
  policy_arn = aws_iam_policy.backend_s3.arn
}

resource "aws_eks_pod_identity_association" "backend" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "backend"
  service_account = "backend-sa"
  role_arn        = aws_iam_role.backend_pod.arn
}