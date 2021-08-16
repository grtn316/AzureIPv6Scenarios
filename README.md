# Deploy Windows and Linux VMs with both IPv4 and IPv6 Addresses

This repository will deploy a given number of Windows or Linux VMs with dual stacked IPs (v4/v6) into a single Availability Zone by setting the variable `linuxComputeCount` and/or `windowsComputeCount` (defaults to 1) and `zone` (defaults to 2) variable.

This code will also create a new resource group for the VMs and connect them to an existing subnet within a VNet by setting the `subnetId` variable (if not set, will create a new VNet).

You will need a create a `variables.tfvars` file and set the __required variable__ for the deployment:
-  `adminPassword`

__Optional variables__ that can be overriden for the deployment:
-  `resourceGroupName`
-  `location`
-  `subnetId`
    - Example: `/subscriptions/<subId>/resourceGroups/<rgName>/providers/Microsoft.Network/virtualNetworks/<vnetName>/subnets/<subnetName>`
-  `serverName`
-  `adminUsername`
-  `vmSKU`
- see additional variables [here](./terraform/examples/variables.tf)


Example *.tfvars file:
```
resourceGroupName="IPv6Test"
adminPassword="123Password!"
#subnetId="/subscriptions/<subId>/resourceGroups/<rgName>/providers/Microsoft.Network/virtualNetworks/<vnetName>/subnets/<subnetName>"
```

## Testing
Run the following commands to test the Terraform example:
```bash
cd /terraform/examples

az login

terraform init 
terraform apply -input=false -auto-approve -var-file="variables.tfvars"
```


# Notes
- See the [Terraform Example](./terraform/examples/main.tf) to understand how to deploy both Windows and Linux VMs in a single deployment using module references.