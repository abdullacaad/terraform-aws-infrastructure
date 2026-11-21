output "web_public_ips" { value = aws_instance.web[*].public_ip }
output "web_public_dns" { value = aws_instance.web[*].public_dns }
output "web_instance_ids" { value = aws_instance.web[*].id }
output "app_private_ips" { value = aws_instance.app[*].private_ip }
output "app_instance_ids" { value = aws_instance.app[*].id }
