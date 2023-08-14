include {
  path = find_in_parent_folders()
}

#dependency "eks" {
#    config_path = "../eks"
#}

inputs = {
  cluster_name            = "prd-globo"
  cluster_oidc_issuer_url = "https://oidc.eks.us-east-1.amazonaws.com/id/F5CE478ECAB7F45D7126B4D32E9F7F19"
}

# To run this terragrunt you need to export kubectl config dir
# export KUBE_CONFIG_PATH=~/.kube/config
terraform {
  source = "git::ssh://git@gitdev.clarobrasil.mobi/devops/manchestergit/terraform/modules/eks-csi-driver.git?ref=master"
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