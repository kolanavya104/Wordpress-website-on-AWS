# Security Group for the ALB
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = module.vpc.vpc_id

  # Allow HTTP and HTTPS access from anywhere for the ALB
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic from the ALB
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB-SG"
  }
}

# Updated Security Group for WordPress EC2 instance
resource "aws_security_group" "wordpress_sg" {
  name   = "wordpress-ec2-sg"
  vpc_id = module.vpc.vpc_id

  # Allow inbound HTTP/HTTPS traffic only from the ALB security group
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Original Inbound rule for SSH access from the bastion host
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  # Allow all outbound traffic (Unchanged)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WordPress-EC2-SG"
  }
}

# Security Group for RDS (MySQL)
resource "aws_security_group" "rds_sg" {
  name   = "rds-mysql-sg"
  vpc_id = module.vpc.vpc_id

  # Allow MySQL access only from the WordPress EC2 security group (Unchanged)
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_sg.id]
  }

  # Allow all outbound traffic (Unchanged)
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
