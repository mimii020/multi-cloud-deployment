resource "aws_iam_policy" "backend_s3" {
  name = "${var.project_name}-backend-s3-policy"
  description = (
    "Allows backend pods"
    "to read configuration from S3"
  )

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]

        Resource = [
          "${aws_s3_bucket.backend.arn}/*"
        ]
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

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backend_s3" {
  role = aws_iam_role.backend_pod.name
  policy_arn = aws_iam_policy.backend_s3.arn
}