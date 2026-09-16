# This file is informational only.
# The project uses a local backend with Terraform workspaces to separate dev and prod state.
# Use:
#   terraform workspace new dev
#   terraform workspace select dev
#   terraform plan -var-file="./environments/dev/terraform.tfvars"

resource_group_name  = "rg-tfstate"
storage_account_name = "sttfstateexampledev"
container_name       = "tfstate"
key                  = "dev/terraform.tfstate"
