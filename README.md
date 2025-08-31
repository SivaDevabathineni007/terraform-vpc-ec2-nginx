
---

# terraform-vpc-ec2-nginx

Terraform IaC to provision an **AWS VPC** with public and private subnets across multiple availability zones, and an **EC2 instance** reachable over HTTP (port 80). The EC2 instance can optionally be bootstrapped with **nginx** via `user_data`.

---

## Features

* **VPC**: CIDR `10.0.0.0/16`
* **Public subnets**: 3 across distinct AZs, each routed to an Internet Gateway
* **Private subnets**: 3 across distinct AZs, no direct internet connectivity
* **Routing**:

  * Public subnets → Internet Gateway
  * Private subnets → local routing only
* **EC2 instance**:

  * Launched in a public subnet
  * Security Group allows inbound TCP/80 from `0.0.0.0/0`
  * Public IP output for testing
  * Optional nginx bootstrap via Terraform variable

---

## Inputs

| Variable         | Description                            | Default         |
| ---------------- | -------------------------------------- | --------------- |
| `name`           | Resource name prefix                   | `iac-challenge` |
| `region`         | AWS region to deploy into              | `us-east-1`     |
| `vpc_cidr_block` | VPC CIDR block                         | `10.0.0.0/16`   |
| `az_count`       | Number of AZs / subnets per tier       | `3`             |
| `instance_type`  | EC2 instance type                      | `t3.micro`      |
| `enable_nginx`   | Bootstrap nginx on EC2 via `user_data` | `false`         |

---

## Outputs

| Output               | Description                            |
| -------------------- | -------------------------------------- |
| `vpc_id`             | ID of the created VPC                  |
| `public_subnet_ids`  | List of public subnet IDs              |
| `private_subnet_ids` | List of private subnet IDs             |
| `instance_public_ip` | Public IP of the EC2 instance          |
| `http_test_url`      | Convenience URL (`http://<public-ip>`) |

---

## Usage

```bash
git clone https://github.com/SivaDevabathineni007/terraform-vpc-ec2-nginx.git
cd terraform-vpc-ec2-nginx

cp terraform.tfvars.dev terraform.tfvars
# edit terraform.tfvars to set region, instance_type, and enable_nginx if desired

terraform init
terraform apply
```

If `enable_nginx = true`, nginx will be installed and started automatically.
Visit the output `http_test_url` in a browser to see the nginx default page.

---

## Example `terraform.tfvars`

```hcl
region         = "us-east-1"
name           = "iac-challenge"
vpc_cidr_block = "10.0.0.0/16"
az_count       = 3
instance_type  = "t3.micro"
enable_nginx   = true
```

---

## Clean Up

Destroy all resources when finished:

```bash
terraform destroy
```

---

## Commit Walkthrough

This repo was built step by step for clarity:

1. Init repo hygiene and docs scaffold
2. Configure AWS provider and root variables
3. Add VPC module (3 public + 3 private subnets, IGW, routes)
4. Wire VPC into root config
5. Add EC2 module with SG allowing TCP/80
6. Wire EC2 into root config, output public IP/URL
7. Add optional nginx bootstrap (`enable_nginx` flag)
8. Update README and example `tfvars`

---
