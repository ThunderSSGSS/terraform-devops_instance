#__________SECURITY_GROUP_allow-ssh____________#

resource "aws_security_group" "allow_ssh" {
    name        = "${var.name}-sg"
    description = "Allow ssh to ${var.name}"
    vpc_id      = var.vpc_id

    ingress {
        description = "Allow ssh from users cidr blocks"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = var.users_cidr_blocks
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Environment = var.environment
        Managed_by  = var.managed_by
    }
}


#______DEVOPS_INSTANCE_NETWORK_INTERFACE_______#

resource "aws_network_interface" "eth0" {
    subnet_id       = var.subnet_id
    private_ips     = [var.private_ip]
    private_ip      = var.private_ip
    security_groups = [aws_security_group.allow_ssh.id]
    tags = {
        Name        = "${var.name}-eth0"
        Environment = var.environment
        Managed_by  = var.managed_by
    }
}

#___________DEVOPS-INSTANCE__________________#

resource "aws_instance" "instance" {
    depends_on = [aws_security_group.allow_ssh]

    ami                 = var.ami_id
    instance_type       = var.instance_type
    availability_zone   = var.subnet_availability_zone
    key_name            = var.key_name

    network_interface {
        device_index            = 0
        network_interface_id    = aws_network_interface.eth0.id
    }

    tags = {
        Name        = var.name
        Environment = var.environment
        Managed_by  = var.managed_by
    }

    user_data = filebase64("${var.user_data_file}")
}


#__________DEVOPS-INSTANCE_ELASTIC_IP__________#

resource "aws_eip" "eip" {
    depends_on                  = [aws_instance.instance]
    vpc                         = true
    network_interface           = aws_network_interface.eth0.id
    associate_with_private_ip   = aws_network_interface.eth0.private_ip
    tags = {
        Name        = "${var.name}-eip"
        Environment = var.environment
        Managed_by  = var.managed_by
    }
}