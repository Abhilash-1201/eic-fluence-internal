output "eks_cluster_id" {
  description = "The name of the cluster"
  value       = aws_eks_cluster.eks.id
}

output "eks_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_eks_cluster.eks.arn
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the Kubernetes API server"
  value       = aws_eks_cluster.eks.endpoint
}

output "iam_arn" {
   value       = aws_iam_role.aws_load_balancer_controller.arn
   description = "aws load balancer controller arn"
}

output "master_sg_id" {
   value       = aws_security_group.eks-sg.id
   description = "eks master additional security group id"
}

output "node_sg_id" {
  value       = aws_security_group.eks_node_sg.id
  description = "eks node security group id"
}

output "worker_node_arn" {
  value       = aws_eks_node_group.eks_node.arn
  description = "eks worker nodes arn for aws auth config"
}
