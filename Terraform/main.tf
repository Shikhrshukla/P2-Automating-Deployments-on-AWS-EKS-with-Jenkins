resource "aws_security_group" "Jenkins-VM-SG" {
  name        = "Jenkins-VM-SG"
  description = "Allow Jenkins, SonarQube & SSH access"

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description        = "Allow TCP traffic"
      from_port          = port
      to_port            = port
      protocol           = "tcp"
      cidr_blocks        = ["0.0.0.0/0"]
      ipv6_cidr_blocks   = []
      prefix_list_ids    = []
      security_groups    = []
      self               = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-VM-SG"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0f918f7e67a3323f0" # Ubuntu 22.04 in ap-south-1
  instance_type          = "t2.large"
  key_name               = "Devops"
  vpc_security_group_ids = [aws_security_group.Jenkins-VM-SG.id]
  user_data              = file("./install.sh")

  root_block_device {
    volume_size = 40
  }

  tags = {
    Name = "Jenkins-SonarQube"
  }
}