output "ec2_ips_named" {
  description = "Public IP of web server"
  value = {
    for i, instance in aws_instance.web_server :
    "${var.ec2_name}-${i + 1}" => instance.public_ip
  }
}