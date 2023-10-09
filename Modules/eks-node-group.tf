resource "aws_iam_role" "eks-node-general" {
  name = "eks-node-group-general"
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
          Service = "ec2.amazonaws.com"
        }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "amazon-EKS-Worker-Node-Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-general.name
}

resource "aws_iam_role_policy_attachment" "amazon-EKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-general.name
}

resource "aws_iam_role_policy_attachment" "amazon-EC2-Container-Registry-ReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-general.name
}

resource "aws_eks_node_group" "node-general" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "nodes-general"
  node_role_arn   = aws_iam_role.eks-node-general.arn
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id,
  ]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  update_config {
    max_unavailable = 1
  }

  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  disk_size      = 20
  instance_types = ["t3.small"]
  labels = {
    role = "nodes-general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon-EKS-Worker-Node-Policy,
    aws_iam_role_policy_attachment.amazon-EKS_CNI_Policy,
    aws_iam_role_policy_attachment.amazon-EC2-Container-Registry-ReadOnly,
  ]
} 