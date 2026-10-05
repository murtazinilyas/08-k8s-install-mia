resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      master  = module.master_node.all
      workers = module.worker_node.all
    }
  )
  filename = "${var.inventory_dir}/hosts.cfg"
}

resource "null_resource" "hosts_hash" {
  triggers = {
    hosts_hash = local_file.hosts_cfg.content_base64sha256
  }

  depends_on = [local_file.hosts_cfg]
}