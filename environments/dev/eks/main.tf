locals {
  account_id = data.aws_caller_identity.current.account_id
  tags = {
    Name      = "${var.cluster_name}"
    Project   = "eks-demo"
    ManagedBy = "terraform"
  }
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "19.16.0"
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  enable_irsa                     = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets


  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${local.account_id}:user/eksadmin"
      username = "cluster-admin"
      groups   = ["system:masters"]
    },
  ]


  eks_managed_node_groups = {
    bottlerocket_nodes = {
      ami_type      = "BOTTLEROCKET_x86_64"
      platform      = "bottlerocket"
      min_size      = 1
      max_size      = 2
      desired_size  = 2
      capacity_type = "SPOT"

      # this will get added to what AWS provides
      bootstrap_extra_args = <<-EOT
      # extra args added
      [settings.kernel]
      lockdown = "integrity"
      EOT
    }
  }

}