module "sonarqube_instance" {
  source             = "../module/sonarqube"
  ami               = "ami-04b4f1a9cf54c11d0"
  instance_type     = "t2.medium"
  key_name         = "t"
  security_group_id = "sg-046679e1377fbf5d1"
  instance_name     = "sonarqube_server"
}
