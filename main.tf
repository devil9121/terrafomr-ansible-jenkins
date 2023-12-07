provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "backend" { #ubuntu.yaml NETADATA - ubuntu
  ami                    = "ami-08e2c1a8d17c2fe17"
  instance_type          = "t2.micro" 
  key_name               = "server-key"
  vpc_security_group_ids = ["sg-06c453c8545747bd2"]
  tags = {
    Name = "u21.local"
  }
  user_data = <<-EOF
  #!/bin/bash
  sudo hostnamectl set-hostname U21.local
EOF
}

resource "aws_instance" "frontend" { #amazon-playbook.yaml NGINX -linux
  ami                    = "ami-0c0d141edc4f470cc"
  instance_type          = "t2.micro"
  key_name               = "server-key"
  vpc_security_group_ids = ["sg-06c453c8545747bd2"]
  tags = {
    Name = "c8.local"
  }
  user_data = <<-EOF
  #!/bin/bash
  # New hostname and IP address
  sudo hostnamectl set-hostname c8.local
  hostname=$(hostname)
  public_ip="$(curl -s https://api64.ipify.org?format=json | jq -r .ip)"

  # Path to /etc/hosts
  echo "${aws_instance.backend.public_ip} $hostname" | sudo tee -a /etc/hosts

EOF
depends_on = [aws_instance.backend]
}

resource "local_file" "inventory" {
  filename = "./inventory.yaml"
  content  = <<EOF
[frontend]
${aws_instance.frontend.public_ip}
[backend]
${aws_instance.backend.public_ip}
EOF
}

output "frontend_public_ip" {
  value = aws_instance.frontend.public_ip
}

output "backend_public_ip" {
  value = aws_instance.backend.public_ip
}