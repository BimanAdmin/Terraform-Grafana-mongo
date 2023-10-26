resource "aws_iam_role" "demo" {
  name = "eks-cluster-demo"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "demo-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo.name
}

variable "cluster_name" {
  default     = "demo"
  type        = string
  description = "AWS EKS CLuster Name"
  nullable    = false
}

resource "aws_eks_cluster" "demo" {
  name     = var.cluster_name
  role_arn = aws_iam_role.demo.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private-us-east-2a.id,
      aws_subnet.private-us-east-2b.id,
      aws_subnet.public-us-east-2a.id,
      aws_subnet.public-us-east-2b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy]
}

# Define the EKS update-kubeconfig command as a local-exec provisioner

resource "null_resource" "update_kubeconfig" {
  triggers = {
    eks_cluster_id = aws_eks_cluster.demo.id
  }

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name demo --region us-east-2"
  }
  depends_on = [aws_eks_cluster.demo]
}

# Define an output to display the kubeconfig update command

output "update_kubeconfig_command" {
  value = null_resource.update_kubeconfig.triggers
}
