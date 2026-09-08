resource "aws_eks_pod_identity_association" "backend" {
  cluster_name = aws_eks_cluster.main.name  
  namespace = "backend"
  service_account = "backend-sa"
  role_arn = aws_iam_role.backend_pod.arn
}