variable "ec2_name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "web-server"

}

variable "ec2_region" {
  description = "Region where the EC2 instance will be created"
  type        = string
  default     = "us-east-1"
}

variable "ec2_ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-091138d0f0d41ff90"

}

variable "ssh_key_name" {
  description = "Name of the SSH key pair to access the EC2 instance"
  type        = string
  default     = "${{secrets.SSH_PRIVATE_KEY}}"
}

variable "ec2_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}