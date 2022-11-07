# AWS Devops Instance Terraform module

Terraform module which creates a EC2 instance and enables ssh. You can use this instance to access your infrastructure (only for dev/test environment). <br>
**Important**: on production environment, I recommend you to set a remote access VPN to access your infrastructure.


## Requirements
The module was tested using:
| Name | Versions |
|------|---------|
| terraform | >= 1.0 |
| aws provider | >= 3.0 |

### Resources Requirements
To use this module you need a some resources:
- VPC ([aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/2.35.0/docs/resources/vpc));
- Public subnet ([aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet));
- Key_pair ([aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/3.3.0/docs/resources/key_pair)).

## Usage

### Example creating a Devops Instance
```hcl
# ...
# Imagine that you have same resources: "aws_vpc.example", "aws_subnet.public_subnet" and "aws_key_pair.example"

module "example_instance" {
    source                      = ...
    # Tags  
    name                        = "devops-instance"
    vpc_id                      = aws_vpc.example.id
    subnet_id                   = aws_subnet.public_subnet.id
    subnet_availability_zone    = aws_subnet.public_subnet.availability_zone
    private_ip                  = cidrhost(aws_subnet.public_subnet.cidr_block, 10)
    user_data_file              = "${path.module}/start_comands.sh"
    key_name                    = aws_key_pair.example.key_name
    users_cidr_blocks           = ["0.0.0.0/0"] # Allow ssh from all ipv4 addresses
}
```

## Resources

| Name | Type | Info |
|------|------|------|
| [aws_security_group.allow_ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource | The name on aws is "${var.name}-sg" |
| [aws_network_interface.eth0](https://registry.terraform.io/providers/hashicorp/aws/3.63.0/docs/resources/network_interface) | resource | The value of the tag "Name" on aws is "${var.name}-eth0" |
| [aws_instance.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource | The value of the tag "Name" on aws is "${var.name}" |
| [aws_eip.eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource | The value of the tag "Name" on aws is "${var.name}-eip" |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Tag 'Name' on all resources | string | null | yes |
| environment | Tag 'Environment' on all resources | string | " " | no |
| managed_by | Tag 'Managed_by' on all resources | string | " " | no |
| vpc_id | Id of the VPC | string | null | yes |
| subnet_id | Id of the subnet, must be a public subnet | string | null | yes |
| subnet_availability_zone | The subnet availability zone | string | null | yes |
| private_ip | The instance private ip | string | null | yes |
| instance_type | The instance type | string | t2.micro | no |
| ami_id | The image id | string | ami-08c40ec9ead489470 | no |
| user_data_file | The file (.sh) which contains the start shell script | string | null | yes |
| key_name | The key name of key pair | string | null | yes |
| users_cidr_blocks | List of cidr blocks that can access the instance via ssh | list(string) | null | yes |



## Outputs

| Name | Description |
|------|-------------|
| instance_id | Id of the instance |
| public_ip | The instance public ip |
| private_ip | The instance private ip |
| ssh_connection_comand | The comand used to connect to the instance |


## DevInfos:
- Name: James Artur (Thunder);
- A DevOps and infrastructure enthusiastics.