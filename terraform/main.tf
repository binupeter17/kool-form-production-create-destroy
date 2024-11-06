#Creating Key Pair
resource "aws_key_pair" "ssh_keypair" {

  key_name   = "${var.project_name}-${var.project_environment}"
  public_key = file("mykey.pub")
  tags = {
    Name = "${var.project_name}-${var.project_environment}"
  }
}



# Creating Frontend Security group
resource "aws_security_group" "frontend" {

  name        = "${var.project_name}-${var.project_environment}-frontend"
  description = "${var.project_name}-${var.project_environment}-frontend"
  vpc_id      = var.default_vpc_id
  tags = {
    Name = "${var.project_name}-${var.project_environment}-frontend"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Creating Frontend  Security group ingress rules
resource "aws_security_group_rule" "frontend_ingress_rule" {

  for_each = toset(var.frontend_ports)

  type              = "ingress"
  from_port         = each.key
  to_port           = each.key
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.frontend.id
}



# Creating Ec2 instance
resource "aws_instance" "frontend" {

  ami                    = data.aws_ami.application_ami.id
  instance_type          = var.ec2_type
  key_name               = aws_key_pair.ssh_keypair.key_name
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.frontend.id]
  tags = {
    Name = "${var.project_name}-${var.project_environment}-frontend"
  }

  lifecycle {
    create_before_destroy = true
  }
  
}

# Adding EIP
resource "aws_eip" "frontend_eip" {
  instance = aws_instance.frontend.id
  domain   = "vpc"
}


#Route53 Record Adding
resource "aws_route53_record" "frontend" {
    
  zone_id = data.aws_route53_zone.public_domain.id
  name    = "${var.hostname}.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [ aws_eip.frontend_eip.public_ip ]

}
