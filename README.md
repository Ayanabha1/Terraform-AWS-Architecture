# Terraform Project: VPC, Subnets, Load Balancer and Auto Scaling Group

This Terraform project automates the deployment of a Virtual Private Cloud (VPC) on Amazon Web Services (AWS). The infrastructure includes a VPC, two public subnets, and two private subnets. Additionally, it sets up a load balancer, a target group, and an auto scaling group with EC2 instances.

## Architecture Overview

This is a terraform project that creates the following resources on AWS:

- A **VPC** with a custom CIDR block
- Two **Public Subnets** and two **Private Subnets** in different availability zones (Number of subnets can be changed in `variable.tf` by simply adding extra CIDR blocks)
- A **Target Group** that registers the instances in the private subnets
- An **Application Load Balancer** that distributes the traffic to the target group
- An **Auto Scaling Group** that deploys a number of EC2 instances in the private subnets based on a launch template
- **Security Groups** for the instances and the load balancer that allow the necessary inbound and outbound rules

## Prerequisites

- You need to have an AWS account and configure your credentials
- You need to have terraform installed on your machine
- You need to have a key pair for SSH access to the instances

## Getting Started

- Clone the repository:  
    ```git clone https://github.com/Ayanabha1/Terraform-AWS-Architecture.git```  
    ```cd Terraform-AWS-Architecture```
- Initialize Terraform:  
  ```terraform init```
- Configure your AWS credentials:  
    Generate an IAM user within your AWS Management Console and enter the corresponding  access and secret keys using  ```aws configure``` in your terminal

## Usage

- Edit the variables.tf file to customize the values for your project
- Run `terraform plan` to see the changes that will be applied
- Run `terraform apply` to create the resources on AWS
- Run `terraform destroy` to delete the resources on AWS

## Outputs

- The project will output the following information:

  - The ID and name of the VPC
  - The IDs and names of the subnets
  - The ARN and DNS name of the load balancer
  - The ARN and name of the target group
  - The ID and name of the auto scaling group
  - The IDs and names of the instances
  - The IDs and names of the security groups

