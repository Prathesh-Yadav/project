resource "aws_instance" "jenkins" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  
  tags = {
    Name = var.instance_name
  }

  user_data = <<-EOF
            #!/bin/bash
            sudo apt update -y
            sudo apt install -y openjdk-17-jdk
            curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
              /usr/share/keyrings/jenkins-keyring.asc > /dev/null
            echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
              https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
              /etc/apt/sources.list.d/jenkins.list > /dev/null
            sudo apt update -y
            sudo apt install -y jenkins
            sudo systemctl enable jenkins
            sudo systemctl start jenkins
            EOF
}
