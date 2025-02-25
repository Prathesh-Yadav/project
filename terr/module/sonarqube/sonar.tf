resource "aws_instance" "sonarqube" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = var.instance_name
  }

  user_data = <<-EOF
              #!/bin/bash
              set -e  # Exit immediately if a command fails

              sudo apt update -y
              sudo apt install -y openjdk-17-jdk wget unzip

              # Download and install SonarQube
              sudo useradd -m -d /opt/sonarqube -s /bin/bash sonar
              cd /opt
              sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.3.79811.zip
              sudo apt install -y unzip
              sudo unzip sonarqube-9.9.3.79811.zip
              sudo mv sonarqube-9.9.3.79811 sonarqube
              sudo chown -R sonar:sonar /opt/sonarqube

              # Create SonarQube service
              cat <<EOT | sudo tee /etc/systemd/system/sonarqube.service
              [Unit]
              Description=SonarQube service
              After=network.target

              [Service]
              Type=forking
              ExecStart=/opt/sonarqube/sonarqube-9.9.3.79811/bin/linux-x86-64/sonar.sh start
              ExecStop=/opt/sonarqube/sonarqube-9.9.3.79811/bin/linux-x86-64/sonar.sh stop
              User=sonar
              Group=sonar
              Restart=always

              [Install]
              WantedBy=multi-user.target
              EOT

              # Wait for file system sync
              sleep 10  # Add a delay to ensure the service file is fully written

              # Reload systemd, enable, and start SonarQube
              sudo systemctl daemon-reload
              sudo systemctl enable sonarqube
              sudo systemctl restart sonarqube

              EOF
}
