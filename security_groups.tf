resource "aws_security_group" "wordpress_sg" {
  name   = "wordpress-sg"
  vpc_id = module.vpc.vpc_id

  # Inbound rule: Allow HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound rule: Allow HTTPS traffic from anywhere (optional)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound rule: Allow SSH access from the bastion host
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/32"]  # Replace with your bastion host IP
  }
  # Inbound rule: Allow SSH access from the bastion host
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]  # Replace with your bastion host IP
  }

  # Outbound rule: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # This allows all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Outbound rule: Allow all outbound traffic
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"  # This allows all outbound traffic
    cidr_blocks = ["10.0.1.0/24"]
  }
  # Outbound rule: Allow all outbound traffic
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"  # This allows all outbound traffic
    cidr_blocks = ["10.0.1.0/32"]
  }
  tags = {
    Name = "WordPress-EC2-SG"
  }
}



# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = module.vpc.vpc_id

  # Allow MySQL access only from the WordPress EC2 instance
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_sg.id]  # This is good practice
  }

  # Consider restricting outbound traffic if not necessary
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS-MySQL-SG"
  }
}



