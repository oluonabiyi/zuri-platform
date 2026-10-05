variable "secret_name" { type = string }

# Terraform creates the empty secret only. The value is set with the AWS CLI,
# so it never appears in Git or in the Terraform state file.
resource "aws_secretsmanager_secret" "backend" {
  name                    = var.secret_name
  description             = "Zuri backend secrets (value set outside Terraform)"
  recovery_window_in_days = 0
}

output "secret_arn" { value = aws_secretsmanager_secret.backend.arn }
output "secret_name" { value = aws_secretsmanager_secret.backend.name }
