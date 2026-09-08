variable "subnet_ids" {
  description = "List of subnet IDs for EKS"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for EKS cluster"
  type        = string
}