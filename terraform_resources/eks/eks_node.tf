################### EKS NODE GROUP #############################
resource "aws_eks_node_group" "eks_node" {
    cluster_name            = aws_eks_cluster.eks.name
    node_group_name         = var.node_group_name
    node_role_arn           = aws_iam_role.node.arn
    subnet_ids              = var.subnet_ids
    capacity_type           = var.node_capacity_type

    scaling_config {
        desired_size        = var.desired_size
        max_size            = var.max_size
        min_size            = var.min_size
    }

    launch_template {
      name                  = aws_launch_template.eks_node.name
      version               = "1"
    }

    depends_on              = [
      aws_eks_cluster.eks,
      aws_iam_role.node
    ]
}


##################### LAUNCH TEMPLATE #############################
resource "aws_launch_template" "eks_node" {
    name                   = var.launch_template_name
    description            = "eks node group launch template"
    instance_type          = var.node_instance_types
    key_name               = var.key_name
    vpc_security_group_ids = [aws_security_group.eks_node_sg.id]
    block_device_mappings {
      device_name          = "/dev/xvda"

      ebs {
          volume_size          = var.volume_size
          volume_type          = var.volume_type
      }
    }

    tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "EKS-MANAGED-NODE"
    }
   }
   
    update_default_version = false

    lifecycle {
    create_before_destroy = true
    }

    depends_on              = [
      aws_eks_cluster.eks,
      aws_iam_role.node
    ]
}
