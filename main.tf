# Create an EC2 instance for WordPress
resource "aws_instance" "wordpress" {
  ami           = "ami-0866a3c8686eaeeba"  # Ubuntu AMI in us-east-1
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = module.vpc.private_subnets[0]
  # Use vpc_security_group_ids instead of security_groups
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  user_data = file("files/userdata.sh")
  
  tags = {
    Name = "WordPress-EC2"
  }
}

# Attach EBS volume for WordPress data
resource "aws_ebs_volume" "wordpress_data" {
  availability_zone = aws_instance.wordpress.availability_zone
  size              = 10
  type              = "gp2"
}

resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.wordpress_data.id
  instance_id = aws_instance.wordpress.id
}

# Create ALB for WordPress
resource "aws_lb" "wordpress_alb" {
  name               = "wordpress-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.wordpress_sg.id]
  subnets            = module.vpc.public_subnets
  enable_deletion_protection = false
}

# Target group for WordPress EC2 instance
resource "aws_lb_target_group" "wordpress_tg" {
  name        = "wordpress-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# ALB listener for HTTP traffic
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}

# Attach EC2 instance to target group
resource "aws_lb_target_group_attachment" "wordpress_attachment" {
  target_group_arn = aws_lb_target_group.wordpress_tg.arn
  target_id        = aws_instance.wordpress.id
  port             = 80
}

# RDS (MySQL) for WordPress
resource "aws_db_instance" "wordpress_rds" {
  identifier              = "wordpress-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage        = 10
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.wordpress_subnet.id

  tags = {
    Name = "WordPress-RDS"
  }
}

# Create a subnet group for RDS instance
resource "aws_db_subnet_group" "wordpress_subnet" {
  name       = "wordpress-db-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "WordPress-DB-Subnet"
  }
}

