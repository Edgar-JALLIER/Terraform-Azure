Ressource groupe : 
rg-EJallier2025_cours-multicloud

az group show --name EJallier2025 --query "{name:name,location:location}" -o table
az vm list-sizes --location francecentral --query "[?name=='Standard_B1s']" -o table