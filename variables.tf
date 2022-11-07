variable "environment" { 
    type    = string 
    default = ""
}

variable "managed_by" {
    type    = string 
    default = ""
}

variable "name" {
    type    = string
}

#_________________SUBNET___________________#

variable "vpc_id" { type = string }

variable "subnet_id" {type = string}

variable "subnet_availability_zone" { type = string }

variable "private_ip" {type = string}

#_________________INSTANCE____________________#

variable "instance_type" {
    type    = string
    default = "t2.micro"
}
 
variable "ami_id" {
    type        = string
    default     = "ami-08c40ec9ead489470" #ubuntu 22
    description = "image id"
}

variable "user_data_file" {
    type        = string
    description = "Name of the file with contain the start shell script"
}

variable "key_name" { type=string }

variable "users_cidr_blocks" { 
    type        = list(string)
    description = "List of allowed cidr blocks to make ssh connections" 
}