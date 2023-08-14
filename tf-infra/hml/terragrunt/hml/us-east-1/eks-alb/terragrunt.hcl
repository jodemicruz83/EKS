include {
  path = find_in_parent_folders()
}

#dependency "eks" {
#    config_path = "../eks"
#}

inputs = {
  cluster_name            = "hml-globo"
  cluster_oidc_issuer_url = "https://oidc.eks.us-east-1.amazonaws.com/id/0EEF0B611185437804ED052064501A50"
}

# To run this terragrunt you need to export kubectl config dir
# export KUBE_CONFIG_PATH=~/.kube/config
terraform {
  source = "git::ssh://git@gitdev.clarobrasil.mobi/devops/manchestergit/terraform/modules/eks-alb.git?ref=master"
  extra_arguments "custom_vars" {
    commands = [
        "apply",
        "plan",
        "destroy",
        "import",
        "push",
        "refresh"
    ]
  }
}