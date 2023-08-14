data "aws_eks_cluster" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.my-cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "my-cluster" {
  source          = "git::ssh://git@gitdev.clarobrasil.mobi/devops/modulos-terraform/modulos-aws/terraform-aws-eks.git?ref=master"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  subnets = var.subnets

  vpc_id            = var.vpc_id
  vpn_ingress_cidrs = var.vpn_ingress_cidrs
  worker_groups     = var.worker_groups
  
  cluster_endpoint_private_access       = var.cluster_endpoint_private_access
  cluster_endpoint_private_access_cidrs = var.cluster_endpoint_private_access_cidrs
  cluster_endpoint_public_access        = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs  = var.cluster_endpoint_public_access_cidrs
  workers_additional_policies           = aws_iam_policy.worker_custom_policy.*.id
  map_roles                             = var.map_roles

  tags = var.tags
}

resource "aws_iam_policy" "worker_custom_policy" {
  count = var.enable_worker_custom_policy == true ? 1 : 0

  name        = "${var.cluster_name}-worker_custom_policy"
  description = "SG to include custom policy in worker nodes"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:*"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:ecr:*:${var.aws_account_id}:repository/*"
        ]
      },
    ]
  })
}
