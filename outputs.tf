output "vpc_output" {
  value = {
    name       = aws_vpc.terraform_vpc.tags["Name"]
    id         = aws_vpc.terraform_vpc.id
    cidr_block = aws_vpc.terraform_vpc.cidr_block
  }
}

output "public_subnet_output" {
  value = {
    name       = aws_subnet.public_subnets[*].tags["Name"]
    id         = aws_subnet.public_subnets[*].id
    cidr_block = aws_subnet.public_subnets[*].cidr_block
  }
}


output "private_subnet_output" {
  value = {
    name       = aws_subnet.private_subnets[*].tags["Name"]
    id         = aws_subnet.private_subnets[*].id
    cidr_block = aws_subnet.private_subnets[*].cidr_block
  }
}


output "load_balancer_output" {
  value = {
    name     = aws_lb.tarraform_alb.tags["Name"]
    id       = aws_lb.tarraform_alb.id
    dns_name = aws_lb.tarraform_alb.dns_name
  }
}


output "target_group_output" {
  value = {
    name = aws_lb_target_group.tarraform_tg.tags["Name"]
    id   = aws_lb_target_group.tarraform_tg.id
    arn  = aws_lb_target_group.tarraform_tg.arn
  }
}

output "auto_scaling_output" {
  value = {
    name = aws_autoscaling_group.terraform_asg.name
    id   = aws_autoscaling_group.terraform_asg.id
    arn  = aws_lb_target_group.tarraform_tg.arn
  }
}

output "bastion_output" {
  value = {
    id        = aws_instance.Bastion.id
    public_ip = aws_instance.Bastion.public_ip
  }
}
