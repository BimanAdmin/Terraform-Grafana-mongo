resource "aws_iam_role" "nodes" {
  name = "eks-node-group-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = [
    aws_subnet.private-us-east-2a.id,
    aws_subnet.private-us-east-2b.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.medium"]

  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  taint {
    key    = "dedicated"
    value  = "grafana"
    effect = "NO_SCHEDULE"
   }

  # launch_template {
  #   name    = aws_launch_template.eks-with-disks.name
  #   version = aws_launch_template.eks-with-disks.latest_version
  # }

  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_eks_node_group" "private-nodes-group2" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "private-nodes-group2"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = [
    aws_subnet.private-us-east-2a.id,
    aws_subnet.private-us-east-2b.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.small"]

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  taint {
    key    = "dedicated"
    value  = "mongo"
    effect = "NO_SCHEDULE"
   }

  # launch_template {
  #   name    = aws_launch_template.eks-with-disks.name
  #   version = aws_launch_template.eks-with-disks.latest_version
  # }

  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}


# resource "aws_launch_template" "eks-with-disks" {
#   name = "eks-with-disks"

#   key_name = "local-provisioner"

#   block_device_mappings {
#     device_name = "/dev/xvdb"

#     ebs {
#       volume_size = 50
#       volume_type = "gp2"
#     }
#   }
# }

###############
# Execute the YAML file for Grafana on EKS cluster

#resource "null_resource" "execute_yaml_file1" {
#  provisioner "local-exec" {
#    command = "kubectl apply -f ./grafana.yaml"
#  }

#  triggers = {
#    eks_cluster_id = aws_eks_cluster.demo.id
#  }

#  depends_on = [aws_eks_cluster.demo, aws_eks_node_group.private-nodes]
#}


# Execute the YAML file for Mongo on EKS cluster

#resource "null_resource" "execute_yaml_file2" {
  
#  provisioner "local-exec" {
#    command = "kubectl apply -f ./mongo.yaml"
#  }

#  triggers = {
#    eks_cluster_id = aws_eks_cluster.demo.id
#  }

#  depends_on = [aws_eks_cluster.demo, aws_eks_node_group.private-nodes]
#}

# Execute the YAML file for Nginx on EKS cluster

#resource "null_resource" "execute_yaml_file3" {
  
#  provisioner "local-exec" {
#    command = "kubectl apply -f ./nginx.yaml"
#  }

#  triggers = {
 #   eks_cluster_id = aws_eks_cluster.demo.id
#  }

#  depends_on = [aws_eks_cluster.demo, aws_eks_node_group.private-nodes]
#}
######################


variable "kubeconfig_path" {
  type    = string
  default = "C:\\Users\\biman\\.kube\\config"
}

variable "yaml_files" {
  type    = list(string)
  default = ["/grafana.yaml", "/mongo.yaml", "/nginx.yaml"]
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

resource "null_resource" "apply_yaml" {
  count = length(var.yaml_files)

  triggers = {
    yaml_file = var.yaml_files[count.index]
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${var.yaml_files[count.index]} --kubeconfig=${var.kubeconfig_path}"
  }
}


