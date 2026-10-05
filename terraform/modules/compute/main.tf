variable "name" { type = string }
variable "instance_type" { type = string }
variable "subnet_id" { type = string }
variable "security_group_ids" { type = list(string) }
variable "instance_profile_name" { type = string }
variable "healthcheck_script_path" { type = string }
variable "health_check_cron" { type = string }

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_instance" "node" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.instance_profile_name

  metadata_options {
    http_tokens                 = "required" # IMDSv2 only
    http_put_response_hop_limit = 2          # lets pods (External Secrets) use the instance role
  }

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    healthcheck_b64   = filebase64(var.healthcheck_script_path)
    health_check_cron = var.health_check_cron
  })

  # A later script or AMI change must never rebuild the server (it would wipe the health report)
  lifecycle {
    ignore_changes = [user_data, ami]
  }

  tags = { Name = "${var.name}-k3s" }
}

output "public_ip" { value = aws_instance.node.public_ip }
output "instance_id" { value = aws_instance.node.id }
