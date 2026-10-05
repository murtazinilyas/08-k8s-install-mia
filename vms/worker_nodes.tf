module "worker_node" { # Создаем виртуальные машины
  source             = "./vm"
  env_name           = var.env_name
  network_id         = module.vpc.network_id
  subnet_zones       = module.vpc.zone
  subnet_ids         = module.vpc.subnet_id
  security_group_ids = module.vpc.security_group_ids
  instance_name      = "worker-node"
  instance_count     = 4
  image_family       = "ubuntu-2204-lts"
  instance_memory    = 2
  public_ip          = true
  private_key        = var.private_key

  metadata = {
    user-data          = data.template_file.cloudinit_worker.rendered
    serial-port-enable = 1
  }

}

data template_file "cloudinit_worker" { # Создаем cloud-init файл
  template = file("./cloud-init-worker.yml")

  vars = {
    username           = var.username
    ssh_public_key     = file(var.public_key)
  }
}
