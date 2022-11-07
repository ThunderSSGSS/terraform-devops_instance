output "instance_id" {
    value = aws_instance.instance.id
}

output "public_ip" {
    value = aws_eip.eip.public_ip
}

output "private_ip" {
    value = var.private_ip
}

output "ssh_connection_comand" {
    value = "ssh -i '${aws_instance.instance.key_name}.pem' ubuntu@${aws_eip.eip.public_ip}"
}