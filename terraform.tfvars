images_names = ["fluence-devops"]
######################### eks###########################################
region_name  = "us-east-2"
cluster_name         = "eks-fluence-dev"
cluster_version      = "1.28"
#subnet_ids           = ["subnet-bbcb73e3", "subnet-9883fbee"] ### Oregon Subnets
subnet_ids           = ["subnet-c7d63abc", "subnet-935052d9"]  ### ohio Subnets
service_ipv4_cidr    = "10.100.0.0/16"
node_group_name      = "eks-fluence-nodegroup"
node_instance_types  = "t3.large"
launch_template_name = "eks_node_group_launch_template"
desired_size         = 2
max_size             = 3
min_size             = 1
key_name             = "ohio"
volume_size          = 20
aws_auth_users = [
      {
        userarn  = "arn:aws:iam::519852036875:user/pavan.a@cloudjournee.com"
        username = "pavan.a@cloudjournee.com"
        groups   = ["system:masters"]
      },
      {
        userarn  = "arn:aws:iam::519852036875:user/abhilash.rl@cloudjournee.com"
        username = "abhilash.rl@cloudjournee.com"
        groups   = ["system:masters"]
      },
      {
        userarn  = "arn:aws:iam::519852036875:user/rajaram.s@cloudjournee.com"
        username = "rajaram.s@cloudjournee.com"
        groups   = ["system:masters"]
      }

]
vpc_id                  = "vpc-54e5273d"
sg_name                 = "fluence-sg"
tags = {
  "Project" : "Fluence_DevOps"
  "Environment" : "DEV"
  "Managed By" : "Terraform"
}
