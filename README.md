# Terraform
## Things to know

### Providers
Each provider provides a resource type or a set of data sources that Terraform can manage and play with. They include, AWS, VMWare, Kubernetes etc

### Input Variables
These are passed to your Terraform Config, These can be dynamically created or statically assigned. If not, you can be prompted at the CLI to enter these values

## Data Sources
These can be computed or queried infra sources that are used in your Terraform Config. Like Resource pools, regions, clusters

## Expressions
These are computed results that can range from literal to variables to indices to maps and many other types. Example is to create a VM and assign the network interface on creation to a virtual switch or dynamically assigning VM names based on count

## Functions
Built in functions like any other language

## Output values
Return values from Terraform, these can be VM Name, IP Address, storage location etc
