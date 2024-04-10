output "cluster_id" {
  description = "The name of the cluster"
  value       = module.eks.eks_cluster_id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.eks.eks_cluster_arn
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the Kubernetes API server"
  value       = module.eks.eks_cluster_endpoint
}

output "master_sg_id" {
  description = "eks master additional security group id"
  value       = module.eks.master_sg_id
}

output "node_sg_id" {
  value       = module.eks.node_sg_id
  description = "eks node security group id"
}

output "worker_node_arn" {
  value       = module.eks.worker_node_arn
  description = "eks worker nodes arn for aws auth config"
}
