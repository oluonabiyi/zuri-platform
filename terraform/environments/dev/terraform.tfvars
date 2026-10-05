region              = "eu-west-2"
environment         = "dev"
vpc_cidr            = "10.10.0.0/16"
public_subnet_cidr  = "10.10.1.0/24"
private_subnet_cidr = "10.10.2.0/24"
admin_cidr          = "88.97.246.187/32" # your public IP: run  curl -s ifconfig.me
instance_type       = "t3.medium"
health_check_cron   = "0 20 * * *" # 20:00 UTC every day
