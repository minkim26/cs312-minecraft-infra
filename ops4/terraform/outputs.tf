output "public_ip" {
  description = "Public IP of the Minecraft EC2 instance. Use this for the Ansible inventory and nmap verification."
  value       = aws_instance.minecraft.public_ip
}

output "instance_id" {
  description = "EC2 instance ID, used for CLI stop/start operations."
  value       = aws_instance.minecraft.id
}
