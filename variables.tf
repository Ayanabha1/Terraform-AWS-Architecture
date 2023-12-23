variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet cidrs"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet cidrs"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones"
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "ami" {
  description = "EC2 AMI"
  default     = "ami-0287a05f0ef0e9d9a"
}

variable "tg_health_check" {
  type = map(string)
  default = {
    "timeout"             = "10"
    "interval"            = "50"
    "path"                = "/"
    "port"                = "3000"
    "unhealthy_threshold" = "3"
    "healthy_threshold"   = "2"
    "matcher"             = "200"
  }
}