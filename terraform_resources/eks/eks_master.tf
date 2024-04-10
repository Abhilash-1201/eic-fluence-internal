################ EKS CLUSTER #####################################
resource "aws_eks_cluster" "eks" {
    name                        =   var.cluster_name
    role_arn                    =   aws_iam_role.cluster.arn
    version                     =   var.cluster_version
    enabled_cluster_log_types   =   var.cluster_enabled_log_types

    vpc_config  {
        security_group_ids      =   [aws_security_group.eks-sg.id]
        subnet_ids              =   var.subnet_ids
        endpoint_private_access =   var.cluster_endpoint_private_access
        endpoint_public_access  =   var.cluster_endpoint_public_access
        public_access_cidrs     =   var.cluster_endpoint_public_access_cidrs
    }

    kubernetes_network_config {
        ip_family               =   var.ip_family
        service_ipv4_cidr       =   var.service_ipv4_cidr
    }

    depends_on                  = [
            aws_iam_role.cluster,
            aws_iam_role.node
    ]

    tags                        = merge(
        {"Name" : "${var.cluster_name}"},
        var.tags
    )
}

################# Cloud watch ################################
#resource "aws_cloudwatch_log_group" "eks_cloudwatch" {

#  name                          = "/aws/eks/${var.cluster_name}/cluster"
#  retention_in_days             = var.cloudwatch_log_group_retention_in_days
#  kms_key_id                    = var.cloudwatch_log_group_kms_key_id
#
#  tags = merge(
#    var.tags,
#    { Name = "/aws/eks/${var.cluster_name}/cluster" }
#  )
#}

##################### AWS LOAD BALANCER CONTROLLER ############
data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "aws_load_balancer_controller_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "aws_load_balancer_controller" {
  assume_role_policy = data.aws_iam_policy_document.aws_load_balancer_controller_assume_role_policy.json
  name               = "aws-load-balancer-controller"
}

resource "aws_iam_policy" "aws_load_balancer_controller" {
  policy = file("${path.module}/AWSLoadBalancerController.json")
  name   = "AWSLoadBalancercontroller"
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach" {
  role       = aws_iam_role.aws_load_balancer_controller.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}

############### Cluster Autoscaler ##################################
data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "cluster_autoscaler" {
  assume_role_policy  = data.aws_iam_policy_document.cluster_autoscaler.json
  name                = "cluster-autoscaler"
}

resource "aws_iam_policy" "aws_cluster_autoscaler" {
  policy     = file("${path.module}/AWSClusterautoscaler.json")
  name       = "awsclusterautoscaler"
}

resource "aws_iam_role_policy_attachment" "aws_cluster_autoscaler" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = aws_iam_policy.aws_cluster_autoscaler.arn
}

