#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#



resource "aws_eks_cluster" "kubernetes-cluster" {
  name     =  "kubernetes-aws-${terraform.workspace}"
  role_arn = aws_iam_role.kubernetes-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.kubernetes-cluster-sg.id,aws_security_group.node-sg.id]
    subnet_ids = var.subnet_ids
    endpoint_private_access =true
    endpoint_public_access=false
  }

  depends_on = [

    aws_iam_role_policy_attachment.kubernetes-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.kubernetes-cluster-AmazonEKSServicePolicy,
  ]
}

#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#




resource "aws_eks_node_group" "kubernetes-nodes" {
  cluster_name    = aws_eks_cluster.kubernetes-cluster.name
  node_group_name = "kubernetes-aws-node-group-${terraform.workspace}"
  node_role_arn   = aws_iam_role.kubernetes-node.arn
  subnet_ids      =  var.subnet_ids
  ami_type        = var.ami_type
  disk_size       = 20

   
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.kubernetes-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.kubernetes-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.kubernetes-node-AmazonEC2ContainerRegistryReadOnly,
    # aws_iam_role_policy_attachment.amazon_eks_worker_node_autoscaler_policy,

  ]
}
