####################### EBS CSI DRIVER ADDON ##############################################
resource "aws_eks_addon" "csi_driver" {
  cluster_name             = aws_eks_cluster.eks.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.19.0-eksbuild.2"
  service_account_role_arn = aws_iam_role.eks_ebs_csi_driver.arn
  depends_on               = [
  aws_eks_cluster.eks,
  aws_eks_node_group.eks_node,
  aws_iam_role.eks_ebs_csi_driver
  ]
}

data "aws_iam_policy_document" "csi" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_ebs_csi_driver" {
  assume_role_policy = data.aws_iam_policy_document.csi.json
  name               = "eks-ebs-csi-driver"
}

resource "aws_iam_policy" "aws_ebs_csi_driver" {
  policy = file("${path.module}/AWSEbsCsiDriver.json")
  name   = "AWSEBSCSIDRIVER"
}


resource "aws_iam_role_policy_attachment" "amazon_ebs_csi_driver" {
  role       = aws_iam_role.eks_ebs_csi_driver.name
  policy_arn = aws_iam_policy.aws_ebs_csi_driver.arn
}
