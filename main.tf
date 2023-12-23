# Target group

resource "aws_lb_target_group" "tarraform_tg" {
  name            = "tarraform-tg"
  port            = 3000
  protocol        = "HTTP"
  vpc_id          = aws_vpc.terraform_vpc.id
  ip_address_type = "ipv4"
  target_type     = "instance"
  health_check {
    timeout             = var.tg_health_check["timeout"]
    interval            = var.tg_health_check["interval"]
    path                = var.tg_health_check["path"]
    port                = var.tg_health_check["port"]
    unhealthy_threshold = var.tg_health_check["unhealthy_threshold"]
    healthy_threshold   = var.tg_health_check["healthy_threshold"]
    matcher             = var.tg_health_check["matcher"]
  }

}


# Application load balancer

resource "aws_lb" "tarraform_alb" {
  name               = "terraform-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]
  ip_address_type    = "ipv4"

  tags = {
    name = "terraform-alb"
  }
}

# Load balancer listener

resource "aws_lb_listener" "terraform_alb_listener" {
  load_balancer_arn = aws_lb.tarraform_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tarraform_tg.arn
  }
}


# Launch template

resource "aws_launch_template" "terraform_lt" {
  name                   = "terraform-lt"
  vpc_security_group_ids = [aws_security_group.asg_sg.id]

  image_id      = var.ami
  instance_type = "t2.micro"
  key_name      = "new_key"
  user_data     = base64encode(file("userdata.sh"))
  tags = {
    Name = "terraform-lt"
  }
}

# Auto scaling group

resource "aws_autoscaling_group" "terraform_asg" {
  name                = "terraform-asg"
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1
  vpc_zone_identifier = [for subnet in aws_subnet.public_subnets : subnet.id]
  target_group_arns   = [aws_lb_target_group.tarraform_tg.arn]

  launch_template {
    id      = aws_launch_template.terraform_lt.id
    version = aws_launch_template.terraform_lt.latest_version
  }
}