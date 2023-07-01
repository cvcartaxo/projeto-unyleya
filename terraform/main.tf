terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


resource "aws_security_group" "example_security_group" {
  name        = "cartaxo-security-group"
  description = "cartaxo security group"

  vpc_id = "vpc-0e7f4a9136e220e9d"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "windows" {
  
  ami           = "ami-0ea6a9ded5194e937"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.example_security_group.id]
  subnet_id     = "subnet-053b1e823ff42c05e"

  tags = {
    Name = "windows-cartaxo"
  }
} 

output "aws_instance_public_dns" {
  value = aws_instance.windows.public_dns
}
