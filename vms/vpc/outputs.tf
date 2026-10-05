output "network_id" {
  value = yandex_vpc_network.k8s_vpc.id
}

output "subnet_id" {
  value = yandex_vpc_subnet.k8s_subnet[*].id
}

output "zone" {
  value = yandex_vpc_subnet.k8s_subnet[*].zone
}

output "security_group_ids" {
  value       = [yandex_vpc_security_group.k8s_sg.id]
}

output "all_net" {
  value = yandex_vpc_network.k8s_vpc
}

output "all_subnet" {
  value = yandex_vpc_subnet.k8s_subnet[*]
}