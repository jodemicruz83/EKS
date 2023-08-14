module "ecr" {
  source = "git::ssh://git@gitdev.clarobrasil.mobi/devops/modulos-terraform/modulos-aws/terraform-aws-ecr.git?ref=master"
  name = var.name
  scan_on_push = var.scan_on_push
  tags = var.tags
}
