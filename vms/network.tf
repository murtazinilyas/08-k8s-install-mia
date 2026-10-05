module "vpc" { # Создаем сеть, подсеть и группу безопасности
  source          = "./vpc"
  env_name        = var.env_name
  subnets         = var.subnets
  ingress_ports   = var.ingress_ports
  sg_ingress_list = var.sg_ingress_list
}
