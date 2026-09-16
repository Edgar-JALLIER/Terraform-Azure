# Terraform Azure - TP

Ce projet deploie une infrastructure Azure avec deux environnements logiques : `dev` et `prod`.

## Principe

- Un seul Resource Group Azure : `rg-EJallier2025_cours-multicloud`
- Les ressources ont un nom different selon l'environnement
- Les states sont separes par Terraform workspaces
- Les variables sont chargees depuis des fichiers `.tfvars`
- Aucun secret ne doit etre versionne dans Git

## Structure actuelle

```text
TP-Terraform/
├─ main.tf
├─ variables.tf
├─ providers.tf
├─ versions.tf
├─ backend.tf
├─ terraform.tfvars
├─ environments/
│  ├─ dev/
│  │  ├─ backend.hcl
│  │  ├─ terraform.tfvars
│  │  └─ terraform.tfvars.example
│  └─ prod/
│     ├─ backend.hcl
│     ├─ terraform.tfvars
│     └─ terraform.tfvars.example
├─ .gitignore
└─ README.md
```

## Variables attendues

```hcl
subscription_id     = "..."
resource_group_name = "rg-EJallier2025_cours-multicloud"
user_id             = "EJallier2025"
environment         = "dev" # ou "prod"
location            = "francecentral"
```

## Rappels importants

- `dev` et `prod` ne partagent pas le meme state
- les noms de ressources incluent l'environnement
- le tag `user` conserve ton identifiant
- les tags `Project`, `Environment` et `ManagedBy` sont presents
- la region reste `francecentral`
- la VM reste en `Standard_B1s` avec disque `Standard_LRS`

## Lancement depuis la racine du projet

Toujours te placer dans le dossier racine :

```powershell
cd "C:\Users\ejallier2025\Documents\TP-Terraform"
```

### Initialisation

```powershell
terraform init
terraform workspace new dev
terraform workspace new prod
```

Si les workspaces existent deja, fais simplement :

```powershell
terraform workspace select dev
```

ou :

```powershell
terraform workspace select prod
```

## Workflow DEV

### Plan

```powershell
terraform workspace select dev
terraform plan -out="dev.tfplan" -var-file=".\environments\dev\terraform.tfvars"
```

### Apply

```powershell
terraform apply "dev.tfplan"
```

Si tu veux lancer sans fichier de plan :

```powershell
terraform apply -var-file=".\environments\dev\terraform.tfvars"
```

## Workflow PROD

### Plan

```powershell
terraform workspace select prod
terraform plan -out="prod.tfplan" -var-file=".\environments\prod\terraform.tfvars"
```

### Apply

```powershell
terraform apply "prod.tfplan"
```

Ou directement :

```powershell
terraform apply -var-file=".\environments\prod\terraform.tfvars"
```

## Nettoyage / destroy

### Detruire DEV

```powershell
terraform workspace select dev
terraform destroy -var-file=".\environments\dev\terraform.tfvars"
```

### Detruire PROD

```powershell
terraform workspace select prod
terraform destroy -var-file=".\environments\prod\terraform.tfvars"
```

## Avant chaque apply

La bonne pratique est toujours :

1. choisir le bon workspace
2. lancer `terraform plan`
3. relire le plan
4. faire `terraform apply`

## Fichiers a ne pas versionner

- `terraform.tfstate`
- `*.tfstate.*`
- les vrais `terraform.tfvars`
- les fichiers de secrets

## Commandes Azure utiles

```powershell
az group show --name rg-EJallier2025_cours-multicloud --query "{name:name,location:location}" -o table
az vm list --resource-group rg-EJallier2025_cours-multicloud -o table
az network vnet list --resource-group rg-EJallier2025_cours-multicloud -o table
```