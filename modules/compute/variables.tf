variable "project_name" { type = string }
variable "environment" { type = string }
variable "instance_type" { type = string }
variable "web_instance_count" { type = number }
variable "app_instance_count" { type = number }
variable "key_name" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "web_security_group_ids" { type = list(string) }
variable "app_security_group_ids" { type = list(string) }
variable "ami_id" {
  description = "Fixed AMI id to use instead of looking up Ubuntu. Leave empty for real AWS; set for LocalStack/moto (e.g. ami-12345678)."
  type        = string
  default     = ""
}
