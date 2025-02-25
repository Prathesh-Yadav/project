module "jenkins_instance" {
  source             = "../module/instance"
  ami               = "ami-04b4f1a9cf54c11d0"  # Add quotes for string values
  instance_type     = "t2.micro"
  key_name         = "t"
  security_group_id = "sg-046679e1377fbf5d1"
  instance_name     = "jenkins_server"
}
