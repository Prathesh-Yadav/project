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
              sudo yum update -y
              sudo yum install -y java-11-openjdk-devel
              sudo wget -O /etc/yum.repos.d/jenkins.repo \
                  https://pkg.jenkins.io/redhat-stable/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
              sudo yum install -y jenkins
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              EOF
}
