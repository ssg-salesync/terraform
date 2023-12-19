
resource "aws_eks_cluster" "eks_cluster" {
  name = "salesync_eks_cluster"
  role_arn     = var.role_arn
  version     = "1.18"

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    subnet_ids = [var.eks_subnet_a_id ,var.eks_subnet_c_id]
    security_group_ids = [var.security_group_ids]
    endpoint_private_access = true
    endpoint_public_access = true
  }
}

resource "aws_eks_node_group" "eks-nodes" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-nodes"
  node_role_arn = var.role_arn
  subnet_ids = [var.eks_subnet_a_id ,var.eks_subnet_c_id]
  instance_types = ["t3a.medium"]
  disk_size = 20
  ami_type = "AL2_x86_64"

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}