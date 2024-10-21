variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key pair for EC2"
  default     = "wordpress"
}

variable "db_username" {
  description = "Database username"
  default     = "wordpress_user"
}

variable "db_password" {
  description = "Database password"
  default     = "supersecret"
  sensitive   = true
}

variable "db_name" {
  description = "WordPress database name"
  default     = "wordpress_db"
}
