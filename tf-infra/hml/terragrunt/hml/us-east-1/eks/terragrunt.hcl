locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  tag_env          = local.region_vars.locals.env
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  tag_region       = local.region_vars.locals.aws_region
}

terraform {
  source = "../../../..//terraform-blueprints/eks"
}

include {
  path = find_in_parent_folders()
}

# Inclusão de variáveis à Blueprint
inputs = {
  cluster_name      = "${local.region_vars.locals.env}-globo"
  cluster_version   = "1.27"

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      resolve_conflicts = "OVERWRITE"
      service_account_role_arn = "arn:aws:iam::${local.account_vars.locals.aws_account_id}:role/ebs-csi-hml-globo"
    }
  }

  vpc_id            = "vpc-05d7f1fcc4f989976"
  vpn_ingress_cidrs = ["172.0.0.0/8", "18.230.143.73/32", "54.90.12.93/32", "3.82.89.146/32", "10.40.22.0/24", "23.23.240.197/32", "18.230.84.114/32", "3.224.187.237/32", "10.212.128.0/21", "54.233.227.5/32", "54.207.116.166/32", "35.247.245.95/32", "35.199.74.140/32"]
  subnets           = ["subnet-01950909e8adf269a", "subnet-02ba2401f021e8d59"] #redes privadas
  
  cluster_endpoint_private_access       = false  # com true da erro no acesso ao endpoint na 443
  cluster_endpoint_public_access        = true 
  cluster_endpoint_private_access_cidrs = ["0.0.0.0/0"]
  enable_worker_custom_policy           = true
  aws_account_id                        = "${local.account_vars.locals.aws_account_id}"

  map_roles = [
    {
      rolearn  = "arn:aws:iam::${local.account_vars.locals.aws_account_id}:role/jenkins-cross-account-role"
      username = "jenkins-cross-account-role"
      groups   = ["system:masters","system:nodes"]
    },
  ]

  worker_groups = [
    {
      instance_type        = "t3.medium"
      #ami_id               = "ami-0a983f3ac62bd72dc"	#amazon-eks-arm64-node-1.21-v20220226
      #ami_id               = "ami-00b2ff9d82352ace6"	#amazon-eks-node-1.21-v20220406
      #ami_id               = "ami-0b8cb62a118d00bdb"
      #ami_id               = "ami-05d559c5fe4e0d6fd" #1.23
      ami_id                = "ami-0ae32cfe425c3643a"

      asg_min_size         = 1
      asg_desired_capacity = 1
      asg_max_size         = 1
      key_name             = "globo-nodes-eks-prd"
      root_volume_size     = 200
    }
  ]
  
  tags = {
    ambiente        = "${local.region_vars.locals.env}"
    torre           = "embratel"
    marca           = ""
    centro-de-custo = ""
    projeto         = "globo"
    servico         = "EKS"
    conta           = "hml-globo"
    plataforma      = "aws"
    produto         = "globo"
  }

}
