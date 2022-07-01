# POC VM


## Requirements

- `az cli`
- `terraform 1.1.9`

## Setup

```
az login
az account set --subscription="your_subscription"
```

## How to deploy

### 1- Initialize terraform configuration

```bash
terraform init
```

> command is used to initialize a working directory containing Terraform configuration files.

### 2- Create terraform workspace

```bash
terraform workspace new dev
```

> command is used to create new terraform workspace. [Read more about workspace](https://www.terraform.io/language/state/workspaces)

### 3- Validate terraform configuration

```bash
terraform validate -var-file=tfvars/dev.tfvars
```

> command is used to validate terraform script

#### 4- Create terraform plan

```bash
terraform plan -var-file=tfvars/dev.tfvars
```

> command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure.

#### 5- Apply terraform plan

```bash
terraform apply -var-file=tfvars/dev.tfvars
```

> command executes the actions proposed in a Terraform plan to create or update infrastructure.

#### 6- Cleanup

```bash
terraform destroy -var-file=tfvars/dev.tfvars -auto-approve
```

> command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.
