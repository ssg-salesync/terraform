resource "aws_iam_policy" "eks_ebs_policy" {
  name = "eks-ebs-policy"
  path = "/"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:AttachVolume",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteSnapshot",
          "ec2:DeleteTags",
          "ec2:DeleteVolume",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumesModifications",
          "ec2:DetachVolume",
          "ec2:ModifyVolume"
        ]
        Effect   = "Allow",
        Resource = "*"
    }]
  })
}


resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = ["eks.amazonaws.com", "ec2.amazonaws.com"]
      }
    }]
  })
}


resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = ["eks.amazonaws.com", "ec2.amazonaws.com"]
      }
    }]
  })
}


resource "aws_iam_role" "eks_sa_role" {
  name = "eks-sa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::370080849531:oidc-provider/oidc.eks.ap-northeast-2.amazonaws.com/id/97EBD2A3048EF0235BBE433E6B079C1F"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.ap-northeast-2.amazonaws.com/id/97EBD2A3048EF0235BBE433E6B079C1F:aud" : "sts.amazonaws.com",
            "oidc.eks.ap-northeast-2.amazonaws.com/id/97EBD2A3048EF0235BBE433E6B079C1F:sub" : "system:serviceaccount:kube-system:ebs-csi-controller"
          }
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "eks_ebs_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.eks_sa_role.name
}


resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}


resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}


resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}


resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}


resource "aws_iam_role_policy_attachment" "ecr-read-only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}


resource "aws_iam_role_policy_attachment" "eks_ebs_policy_master_attachment" {
  policy_arn = aws_iam_policy.eks_ebs_policy.arn
  role       = aws_iam_role.eks_cluster_role.name
}


resource "aws_iam_role_policy_attachment" "eks_ebs_policy_node_attachment" {
  policy_arn = aws_iam_policy.eks_ebs_policy.arn
  role       = aws_iam_role.eks_node_role.name
}


output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}


output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}