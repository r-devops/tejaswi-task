resource "aws_security_group" "bastion_instance_sg" {
  vpc_id = var.vpc_id
  name = lookup(var.tags, "Name", null)
  dynamic "ingress" {
    for_each = var.security_group_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

resource "aws_instance" "ec2_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  user_data              = var.user_data
  vpc_security_group_ids = [aws_security_group.bastion_instance_sg.id]
  tags                   = var.tags
}
