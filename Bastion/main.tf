terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
  }
  
  provider "aws" {
    region = "us-east-1"
  }
  
  # Data source to get the VPC ID for wordpress-vpc
  data "aws_vpc" "wordpress_vpc" {
    filter {
      name  = "tag:Name"
      values = ["wordpress-vpc"]
    }
  }
  
  # Data source to get the public subnet ID for public-subnet-east1
  data "aws_subnet" "public_subnet_east1" {
    filter {
      name  = "tag:Name"
      values = ["wordpress-vpc-public-us-east-1a"]
    }
    vpc_id = data.aws_vpc.wordpress_vpc.id
  }
  
  # Security group with specific rules (recommended)
  resource "aws_security_group" "wordpress_sg" {
    name        = "wordpress-security-group"
    description = "Security group for WordPress instance"
    vpc_id      = data.aws_vpc.wordpress_vpc.id
  
    ingress {
      from_port = 22  # Allow SSH access only
      to_port   = 22
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Restrict to specific IP later (optional)
    }
  
    ingress {
      from_port = 80  # Allow HTTP traffic
      to_port   = 80
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Restrict to specific IP later (optional)
    }
  
    # Egress rules are usually left open for outbound traffic
    egress {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  
  # EC2 instance configuration with security group
  resource "aws_instance" "wordpress_instance" {
    ami           = "ami-0866a3c8686eaeeba"  # Example Ubuntu AMI in us-east-1
    instance_type = "t2.micro"
    key_name      = "wordpress"
    subnet_id     = data.aws_subnet.public_subnet_east1.id
    associate_public_ip_address = true  # Ensure this is set to true for auto-assigned public IP
    vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  
    tags = {
      Name = "Bastion"
    }
  }
