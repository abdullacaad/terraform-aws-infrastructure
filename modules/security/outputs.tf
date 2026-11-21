output "web_security_group_id" { value = aws_security_group.web.id }
output "ssh_security_group_id" { value = aws_security_group.ssh.id }
output "app_security_group_id" { value = aws_security_group.app.id }
