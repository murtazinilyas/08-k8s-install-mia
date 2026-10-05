###cloud vars
variable "public_key" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
  description = "Path to public key"
}

variable "private_key" {
  type    = string
  default = "~/.ssh/id_ed25519"
  description = "Path to private key"
}

variable "username" {
  type    = string
  default = "user"
  description = "Username"
}

variable "subnets" {
  type    = list(object({zone = string, cidr = list(string)}))
  default = [
    { zone = "ru-central1-a", cidr = ["10.0.1.0/24"]},
    { zone = "ru-central1-b", cidr = ["10.0.2.0/24"]},
    { zone = "ru-central1-d", cidr = ["10.0.3.0/24"]},
    { zone = "ru-central1-e", cidr = ["10.0.4.0/24"]},
    ]
}

variable "ingress_ports" {
  type = map(string)
  default = {
    "SSH access"                     = "22",
    "K8s API access"                 = "6443"
    "Kubelet API access"             = "10250"
    "kube-scheduler access"          = "10259"
    "kube-controller-manager access" = "10257"
    "kube-proxy access"              = "10256"
  }
  description = "Ingress ports."
}

variable "sg_ingress_list" {
  description = "secrules ingress"
  type = list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  }))
  default = [
    {
      protocol       = "TCP"
      description    = "etcd server client API"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 2379
      to_port        = 2380
    },
    {
      protocol       = "TCP"
      description    = "NodePort Services"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 30000
      to_port        = 32767
    },
    {
      protocol       = "UDP"
      description    = "NodePort Services"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 30000
      to_port        = 32767
    },
  ]
}

variable "env_name" {
  type        = string
  default     = "k8s-install"
  description = "Environment name"
}

variable "inventory_dir" {
  type        = string
  default     = "/home/van/homeworks/k8s/09-k8s-kubeadm_kubespray/kubespray/inventory/mycluster"
  description = "Inventory directory"
}

variable "playbook_dir" {
  type        = string
  default     = "/home/van/homeworks/k8s/09-k8s-kubeadm_kubespray/kubespray"
  description = "Playbook directory"
}