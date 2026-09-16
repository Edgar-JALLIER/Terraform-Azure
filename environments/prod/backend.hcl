# This file is informational only.
# The project uses a local backend with Terraform workspaces to separate dev and prod state.
# Use:
#   terraform workspace new prod
#   terraform workspace select prod
#   terraform plan -var-file="./environments/prod/terraform.tfvars"

resource_group_name  = "rg-tfstate"
storage_account_name = "sttfstateexampleprod"
container_name       = "tfstate"
key                  = "prod/terraform.tfstate"
