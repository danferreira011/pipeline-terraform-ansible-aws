output "web_server_public_ip" {
  description = "Public IP of web server"

  value = aws_instance.web_server.public_ip
}