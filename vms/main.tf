module "master_node" { # Создаем виртуальные машины
  source             = "./vm"
  env_name           = var.env_name
  network_id         = module.vpc.network_id
  subnet_zones       = module.vpc.zone
  subnet_ids         = module.vpc.subnet_id
  security_group_ids = module.vpc.security_group_ids
  instance_name      = "master-node"
  instance_count     = 1
  instance_cores     = 4
  instance_core_fraction = 100
  instance_memory    = 4
  image_family       = "ubuntu-2204-lts"
  public_ip          = true
  private_key         = var.private_key

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }

}

data template_file "cloudinit" { # Создаем cloud-init файл
  template = file("./cloud-init.yml")

  vars = {
    username           = var.username
    ssh_public_key     = file(var.public_key)
  }
}
