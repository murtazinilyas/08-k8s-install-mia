terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">1.12.0"
}

resource "yandex_vpc_network" "k8s_vpc" {
  name = var.env_name == null ? "${var.instance_name}" : "${var.env_name}-${var.instance_name}"
}

resource "yandex_vpc_subnet" "k8s_subnet" {
  count          = length(var.subnets)
  name           = var.env_name == null ? "${var.instance_name}-${var.subnets[count.index].zone}" : "${var.env_name}-${var.instance_name}-${var.subnets[count.index].zone}"
  zone           = var.subnets[count.index].zone
  network_id     = yandex_vpc_network.k8s_vpc.id
  v4_cidr_blocks = var.subnets[count.index].cidr
}

resource "yandex_vpc_security_group" "k8s_sg" {
  name       = var.env_name == null ? "${var.instance_name}-sg" : "${var.env_name}-${var.instance_name}-sg" 
  network_id = yandex_vpc_network.k8s_vpc.id

  egress { # Разрешаем весь исходящий трафик
    protocol          = "ANY"
    v4_cidr_blocks    = var.allowed_cidr
    description       = "Allow all outgoing traffic"
  }

  dynamic "ingress" { # Разрешаем входящий трафик по определенным портам
    for_each = var.ingress_ports
    content {
      protocol          = "TCP"
      port              = ingress.value
      v4_cidr_blocks    = var.allowed_cidr
      description       = ingress.key
    }
  }

  dynamic "ingress" {
    for_each = var.sg_ingress_list
    content {
      protocol       = lookup(ingress.value, "protocol", null)
      description    = lookup(ingress.value, "description", null)
      port           = lookup(ingress.value, "port", null)
      from_port      = lookup(ingress.value, "from_port", null)
      to_port        = lookup(ingress.value, "to_port", null)
      v4_cidr_blocks = lookup(ingress.value, "v4_cidr_blocks", null)
    }
  }

  ingress { # Разрешаем входящий трафик внутри группы безопасности
    protocol          = "ANY"
    predefined_target = "self_security_group"
  }
}