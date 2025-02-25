module "jenkins_instance" {
  source             = "../module/instance"
  ami               = var.ami
  instance_type     = var.instance_type
  key_name         = var.key_name
  security_group_id = var.security_group_id
  instance_name     = var.instance_name
}
