Host your WordPress Website

Objective: As a cloud engineer, I want to host my WordPress website on AWS.
Requirements:
● The website should be hosted in a Virtual Private Cloud (VPC) with the website server running in the private subnet.
● You can host databases on the same server or use AWS Relational Database Service(RDS). You can choose a database technology of your choice.
● The WordPress website should NOT be accessing the database using root credentials and access to the WordPress database should be restricted to the WordPress database user ONLY.
● You can use Apache and Nginx as your web server.
● The WordPress website should be accessible via AWS Application Load Balancer (ALB) or AWS Elastic Load Balancer (ELB).
● The WordPress website content should be on a separate EBS volume (size less than 10 GB). The separate EBS volume should be mounted on the website server and it should be ext4. You can choose your mount point or document root for this.
● Deploying and securing this application based on the AWS well-architected framework is
recommended
Additional Specifications:
● Operating System - Amazon Linux 2 or Ubuntu 20.04/Ubuntu 18.04
● AWS EC2 and RDS Instance Type - t2.micro or t3.micro
● AWS EBS Volume Disk Size - Less than 10 GB
● AWS Region - us-east-1 (Northern Virginia)
Deliverables
● Overall Architecture Diagram
● Documentation
● Link to Website URL i.e., AWS Application Load Balancer or AWS Elastic Load Balancer
URL



Here we are following 15 steps
1.Create VPC
2.Create Subnets
3.Create Route tables
3.Create Internet Gateway
4.Attach Internet Gateway
5.Create Nat Gateway
6.Attach Nat gateway
7.Create rds Subnet groups
8.Create rds
9.Create Private Instance
10.Create Bastion Host
11.Install wordpress on Private Instance
12.Create Target Group for this private instance
13.Create alb
15.Attach EBS
