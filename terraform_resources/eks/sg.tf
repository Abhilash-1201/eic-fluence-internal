#################### EKS MASTER SECURITY GROUP AND RULES #############
resource "aws_security_group" "eks-sg" {
    vpc_id                      =   var.vpc_id
    name                        =   "eks_master_sg"
    description                 =   "Allow inbound traffic from the security groups for MYSQL"
    tags                        =   merge(
        {"Name" : "sg-${var.cluster_name}"},
        var.tags
    )
}

resource "aws_security_group_rule" "ingress_https" {
    security_group_id           =   aws_security_group.eks-sg.id
    description                 =   "Allow inbound traffic from existing Security Groups"
    type                        =   "ingress"
    from_port                   =   443
    to_port                     =   443
    protocol                    =   "tcp"
    cidr_blocks                 = ["0.0.0.0/0"]       
    depends_on                  = [
        aws_security_group.eks-sg,
        ]
}

resource "aws_security_group_rule" "ingress_http" {
    security_group_id           =   aws_security_group.eks-sg.id
    description                 =   "Allow inbound traffic from existing Security Groups"
    type                        =   "ingress"
    from_port                   =   80
    to_port                     =   80
    protocol                    =   "tcp"
    cidr_blocks                 = ["0.0.0.0/0"]
    depends_on                  = [
        aws_security_group.eks-sg,
        ]
}

resource "aws_security_group_rule" "ingress_rds" {
    security_group_id           =   aws_security_group.eks-sg.id
    description                 =   "Allow inbound traffic from existing Security Groups"
    type                        =   "ingress"
    from_port                   =   22
    to_port                     =   22
    protocol                    =   "tcp"
    cidr_blocks                 =   ["10.212.134.0/24", "10.0.0.0/20"]
    depends_on                  = [
        aws_security_group.eks-sg,
        aws_security_group.eks_node_sg
        ]
}


resource "aws_security_group_rule" "egress" {
    description                   = "Allow all egress traffic"
    type                          = "egress"
    from_port                     = 0
    to_port                       = 0
    protocol                      = "-1"
    cidr_blocks                   = ["0.0.0.0/0"]
    security_group_id             = aws_security_group.eks-sg.id
    depends_on                  = [
        aws_security_group.eks-sg
        ]

}


################## EKS NODES SECURITY GROUP AND RULES ##################
resource "aws_security_group" "eks_node_sg" {
    vpc_id                      =   var.vpc_id
    name                        =   "eks_node_sg"
    description                 =   "Allow inbound traffic from the security groups for eks node"
    tags                        =   merge(
        {"Name" : "eks_node_sg_${var.cluster_name}"},
        var.tags
    )

}


resource "aws_security_group_rule" "ingress" {
    security_group_id           =   aws_security_group.eks_node_sg.id
    type                        =   "ingress"

    from_port                   = 8285
    to_port                     = 8285
    description                 = "application port number"
    protocol                    = "udp"

    source_security_group_id    =   aws_security_group.eks-sg.id
    depends_on                  = [
        aws_security_group.eks_node_sg,
        aws_security_group.eks-sg
        ]
}

resource "aws_security_group_rule" "ingress_10250" {
    security_group_id           =   aws_security_group.eks_node_sg.id
    type                        =   "ingress"

    from_port                   = 10250
    to_port                     = 10250
    description                 = "application port number"
    protocol                    = "tcp"

    source_security_group_id    =   aws_security_group.eks-sg.id
    depends_on                  = [
        aws_security_group.eks_node_sg,
        aws_security_group.eks-sg
        ]
}

resource "aws_security_group_rule" "ingress_30000" {
    security_group_id           =   aws_security_group.eks_node_sg.id
    type                        =   "ingress"

    from_port                   = 32540
    to_port                     = 32540
    description                 = "prometheus port number"
    protocol                    = "tcp"

    cidr_blocks                 = ["0.0.0.0/0"]
    depends_on                  = [
        aws_security_group.eks_node_sg,
        aws_security_group.eks-sg
        ]
}

resource "aws_security_group_rule" "ingress_32000" {
    security_group_id           =   aws_security_group.eks_node_sg.id
    type                        =   "ingress"

    from_port                   = 32000
    to_port                     = 32000
    description                 = "prometheus port number"
    protocol                    = "tcp"
    cidr_blocks                 = ["0.0.0.0/0"]
    depends_on                  = [
        aws_security_group.eks_node_sg,
        aws_security_group.eks-sg
        ]
}



resource "aws_security_group_rule" "ingress_44" {
    security_group_id           =   aws_security_group.eks_node_sg.id
    type                        =   "ingress"

    from_port                   = 443
    to_port                     = 443
    description                 = "application port number"
    protocol                    = "tcp"

    source_security_group_id    =   aws_security_group.eks-sg.id
    depends_on                  = [
        aws_security_group.eks_node_sg,
        aws_security_group.eks-sg
        ]
}

resource "aws_security_group_rule" "ingress_9443" {
    security_group_id           =   aws_security_group.eks_node_sg.id
    type                        =   "ingress"

    from_port                   = 9443
    to_port                     = 9443
    description                 = "application port number"
    protocol                    = "tcp"

    source_security_group_id    =   aws_security_group.eks-sg.id
    depends_on                  = [
        aws_security_group.eks_node_sg,
        aws_security_group.eks-sg
        ]
}


resource "aws_security_group_rule" "ingress_node" {
    security_group_id           =   aws_security_group.eks_node_sg.id
    type                        =   "ingress"

    from_port                   = 0
    to_port                     = 0
    description                 = "Allow access from control plane to webhook port of AWS load balancer controller"
    protocol                    = "-1"
    self                        = true
    depends_on                  = [
        aws_security_group.eks_node_sg,
        aws_security_group.eks-sg
        ]
}

resource "aws_security_group_rule" "ingress_node_rds" {
    security_group_id           =  aws_security_group.eks_node_sg.id
    type                        =  "ingress"

    from_port                   = 22
    to_port                     = 22
    description                 = "Allow access from control plane to webhook port of AWS load balancer controller"
    protocol                    = "tcp"
    cidr_blocks                 = ["10.212.134.0/24", "10.0.0.0/20"]
    depends_on                  = [
        aws_security_group.eks_node_sg,
        aws_security_group.eks-sg
        ]
}

resource "aws_security_group_rule" "kafka_9092" {
    security_group_id           =  aws_security_group.eks_node_sg.id
    type                        =  "ingress"

    from_port                   = 9092
    to_port                     = 9092
    description                 = "Allow access from control plane to webhook port of AWS load balancer controller"
    protocol                    = "tcp"
    cidr_blocks                   = ["0.0.0.0/0"]    
    depends_on                  = [
        aws_security_group.eks_node_sg,
        aws_security_group.eks-sg
        ]
}

resource "aws_security_group_rule" "kafka_15762" {
    security_group_id           =  aws_security_group.eks_node_sg.id
    type                        =  "ingress"

    from_port                   = 31000
    to_port                     = 31000
    description                 = "Allow access from control plane to webhook port of AWS load balancer controller"
    protocol                    = "tcp"
    cidr_blocks                   = ["0.0.0.0/0"]
    depends_on                  = [
        aws_security_group.eks_node_sg,
        aws_security_group.eks-sg
        ]
}


resource "aws_security_group_rule" "node_egress" {
    description                   = "Allow all egress traffic"
    type                          = "egress"
    from_port                     = 0
    to_port                       = 0
    protocol                      = "-1"
    cidr_blocks                   = ["0.0.0.0/0"]
    security_group_id             = aws_security_group.eks_node_sg.id
    depends_on                  = [
        aws_security_group.eks_node_sg,
        aws_security_group.eks-sg
        ]

}
