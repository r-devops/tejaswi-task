variable "aws_region" {
  default = "us-east-1" // This needs to changed as per your need
}

variable "vpc_id" {
  default = "vpc-0a1819d9e89b1942b" // This needs to changed as per your need
}

variable "key_name" {
  type    = string
  default = "naga-pair" // This needs to changed as per your need
}


variable "ec2_instances" {
default = {
  bastion = {
    ami = "ami-03265a0778a880afb" // This needs to changed as per your need
    instance_type = "t3.small"
    subnet_id = "subnet-087aaf3cc8b72f5e6"  // This needs to changed as per your need
    security_group_rules = [
      {
        type        = "ingress"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    user_data = null
    tags = {
      Name = "bastion"
    }
  }

  jenkins = {
    ami = "ami-03265a0778a880afb" // This needs to changed as per your need
    instance_type = "t3.small"
    subnet_id = "subnet-0738fb4d3a94831b2" // This needs to changed as per your need
    security_group_rules = [
      {
        type        = "ingress"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["172.31.0.0/16"] // This needs to changed as per your need
      },
      {
        description = "HTTP ingress"
        type        = "ingress"
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["172.31.0.0/16"] // This needs to changed as per your need
      }
    ]
    user_data = "install_jenkins.sh"
    tags = {
      Name = "jenkins"
    }
  }
}
}

variable "lb_subnets" {
  default = ["subnet-0738fb4d3a94831b2", "subnet-087aaf3cc8b72f5e6"] // This needs to changed as per your need
}

variable "lb_tags" {
  default = {
    Name = "alb"
  }
}

variable "lb_security_group_rules" {
  default = [
    {
      description = "HTTP ingress"
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] // This needs to changed as per your need
    }
  ]
}