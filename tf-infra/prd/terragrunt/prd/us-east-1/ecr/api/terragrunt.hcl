locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  tag_env          = local.region_vars.locals.env
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  tag_region       = local.region_vars.locals.aws_region
}

terraform {  
  source = "../../../../..//terraform-blueprints/ecr"
}

include {
  path = find_in_parent_folders()
}

# Inclusão de variáveis à Blueprint
inputs = {
  name = "${local.region_vars.locals.env}-globo-api"
  scan_on_push = false

  tags = {
    ambiente        = "${local.region_vars.locals.env}"
    torre           = "embratel"
    marca           = ""
    centro-de-custo = ""
    projeto         = "globo"
    servico         = "ECR"
    conta           = "embratel-prd-globo"
    plataforma      = "aws"
    produto         = "globo"
  }
}
