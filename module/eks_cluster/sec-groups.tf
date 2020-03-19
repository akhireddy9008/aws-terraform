# control plane security group
resource "aws_security_group" "kubernetes-cluster-sg" {
  name        = "terraform-eks-kubernetes-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }


   tags = {
     Name                                                         = "kubernetes-aws-${terraform.workspace}-eks-node-sg"
    "kubernetes.io/cluster/kubernetes-aws-${terraform.workspace}" = "owned"
  }
}

resource "aws_security_group_rule" "kubernetes-cluster-ingress" {
 
  description       = "Allow pods to communicate with the cluster API Server"
    from_port         = 443
    protocol          = "tcp"
    security_group_id = aws_security_group.kubernetes-cluster-sg.id
    to_port           = 443
    source_security_group_id = aws_security_group.node-sg.id
    type              = "ingress"
}
resource "aws_security_group_rule" "kubernetes-cluster-bastion-ingress" {
 
  description       = "allow ingress traffic from your bastion host"
    from_port         = 443
    protocol          = "tcp"
    security_group_id = aws_security_group.kubernetes-cluster-sg.id
    to_port           = 443
    source_security_group_id = var.source_security_group_id
    type              = "ingress"
}

#node plane security group 
resource "aws_security_group" "node-sg" {
  name        = "terraform-eks-kubernetes-node-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
     Name                                                        = "kubernetes-aws-${terraform.workspace}-eks-node-sg"
    "kubernetes.io/cluster/kubernetes-aws-${terraform.workspace}" = "owned"
  }
}
resource "aws_security_group_rule" "kubernetes-node-ingress" {
 
  description       = "Allow workstation to communicate with the cluster API Server"
    from_port         = 1025
    security_group_id = aws_security_group.node-sg.id
    protocol          = "tcp"
    to_port           = 65535
    source_security_group_id = aws_security_group.kubernetes-cluster-sg.id
    type              = "ingress"
}