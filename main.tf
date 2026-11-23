terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-2"
}

# Find the latest official Ubuntu 24.04 AMI

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create Ubuntu EC2 instance

resource "aws_instance" "ubuntu_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform-Ubuntu-Server"
  }
}

# Outputs

output "instance_id" {
  value = aws_instance.ubuntu_server.id
}

output "public_ip" {
  value = aws_instance.ubuntu_server.public_ip
}

output "ubuntu_ami" {
  value = aws_instance.ubuntu_server.ami
}

output "ubuntu_id" {
  value = data.aws_ami.ubuntu.id
}
