locals {
  account_vars  = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars   = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env           = "prd"
  project_name  = "embratel"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  vpc_cidr_block = "10.86.58.0/24"
  public_subnet1_cidr_block = "10.86.58.128/27"
  public_subnet2_cidr_block = "10.86.58.160/27"
  private_subnet1_cidr_block = "10.86.58.0/26"
  private_subnet2_cidr_block = "10.86.58.64/26"
  availability_zone1 = "us-east-1a"
  availability_zone2 = "us-east-1b"
  region = "us-east-1"
  project_name = "embratel"

  tags = {
    torre           = "ti"
    centro-de-custo = "x"
    conta           = "${local.account_vars.locals.account_name}"
    plataforma      = "aws"
    ambiente        = "${local.env}"
    marca           = "claro"
    produto         = "globo"
    projeto         = "${local.project_name}"
    servico         = "VPC"
    "kubernetes.io/cluster/prd-globo" = "shared"
  }
}

terraform {
  //source = "git::git@gitdev.clarobrasil.mobi/devops/manchestergit/terraform/modules/vpc.git//module?ref=v0.1.0"
  source = "git::ssh://git@gitdev.clarobrasil.mobi/devops/manchestergit/terraform/modules/vpc.git//module?ref=claro-ti-v2"
}