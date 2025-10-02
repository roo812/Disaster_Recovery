data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "main" {
  name                   = "app-lt"
  image_id               = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [var.ec2_sg_id]
  iam_instance_profile {
    arn = var.instance_role
  }
  # user_data = base64encode(<<-EOF
  #             #!/bin/bash
  #             yum update -y
  #             yum install -y python3 python3-pip mysql
  #             pip3 install flask mysql-connector-python
  #             aws s3 cp s3://${var.app_bucket}/app.py /home/ec2-user/app.py
  #             aws s3 cp s3://${var.app_bucket}/requirements.txt /home/ec2-user/requirements.txt
  #             aws s3 cp s3://${var.app_bucket}/init_db.sql /home/ec2-user/init_db.sql
  #             pip3 install -r /home/ec2-user/requirements.txt
  #             mysql -h ${var.db_endpoint} -u ${var.db_username} -p${var.db_password} < /home/ec2-user/init_db.sql
  #             export DB_HOST=${var.db_endpoint}
                
  #             nohup python3 /home/ec2-user/app.py &
  #             EOF
  #       )
  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Update and install dependencies
    yum update -y
    yum install -y python3 python3-pip mysql

    # Install Python packages
    pip3 install flask mysql-connector-python

    # Download app files from S3
    aws s3 cp s3://${var.app_bucket}/app.py /home/ec2-user/app.py
    aws s3 cp s3://${var.app_bucket}/requirements.txt /home/ec2-user/requirements.txt
    aws s3 cp s3://${var.app_bucket}/init_db.sql /home/ec2-user/init_db.sql

    # Install requirements
    pip3 install -r /home/ec2-user/requirements.txt

    # Initialize DB (retry loop in case DB is not ready)
    for i in {1..10}; do
      mysql -h ${var.db_endpoint} -u ${var.db_username} -p${var.db_password} < /home/ec2-user/init_db.sql && break
      echo "DB not ready yet... retrying in 15s"
      sleep 15
    done

    # Run Flask app with environment variables
    DB_HOST=${var.db_endpoint} DB_USER=${var.db_username} DB_PASS=${var.db_password} nohup python3 /home/ec2-user/app.py &
    EOF
    )

}

resource "aws_autoscaling_group" "main" {
  name                = "app-asg"
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1
  vpc_zone_identifier = var.subnets
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
  target_group_arns = [var.alb_tg_arn]
}