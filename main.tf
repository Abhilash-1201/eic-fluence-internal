module "eks" {
  source               = "./terraform_resources/eks"
  vpc_id               = var.vpc_id
  region_name          = var.region_name
  cluster_name         = var.cluster_name
  cluster_version      = var.cluster_version
  subnet_ids           = var.subnet_ids
  service_ipv4_cidr    = var.service_ipv4_cidr
  node_group_name      = var.node_group_name
  node_instance_types  = var.node_instance_types
  launch_template_name = var.launch_template_name
  desired_size         = var.desired_size
  max_size             = var.max_size
  min_size             = var.min_size
  aws_auth_users       = var.aws_auth_users
  key_name             = var.key_name
  volume_size          = var.volume_size
  tags                 = var.tags
}
#################### ECR MODULE ###################################
module "ecr" {
    source                  = "./terraform_resources/ecr"
    image_names             = var.images_names
    tags                    = var.tags
    depends_on              = [
              module.eks
     ]
}



