# Домашнее задание к занятию «Установка Kubernetes»

### Цель задания

Установить кластер K8s.

### Чеклист готовности к домашнему заданию

1. Развёрнутые ВМ с ОС Ubuntu 20.04-lts.


### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция по установке kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).
2. [Документация kubespray](https://kubespray.io/).

-----

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.

------

### Решение 1.

Выбрал установку с помощью kubespray. Использовал версию Ubuntu 22.04-lts, так как в 20.04-lts из коробки установлена неподдерживаемая текущим билдом kubespray версия python.

Скопировал kubespray с github, подготовил конфигурацию.

Написал [terraform манифесты](https://github.com/murtazinilyas/08-k8s-install-mia/tree/main/vms) для создания машин и inventory-файла в директорию с конфигурацией kubespray.

Пример [inventory-файла](https://github.com/murtazinilyas/08-k8s-install-mia/blob/main/hosts.cfg)

Запустил установку kubespray командой `ansible-playbook -i inventory/mycluster/hosts.cfg cluster.yml`

Естественно с первого раза не получилось запустить плейбук, нужно было подготовить виртуальное окружение (из-за неподдерживаемой версии Ansible) и установить необходимые зависимости для работы с kubespray.

Результат установки:

![kubespray](https://github.com/murtazinilyas/08-k8s-install-mia/blob/main/screenshots/kubespray.png)

Вывод команды `kubectl get nodes` на мастер-ноде:

![get_nodes](https://github.com/murtazinilyas/08-k8s-install-mia/blob/main/screenshots/get_nodes.png)

Написал и запустил тестовые под и сервис из второго задания, запустил port-forward, проверил работу:

![test1](https://github.com/murtazinilyas/08-k8s-install-mia/blob/main/screenshots/test1.png)

![test2](https://github.com/murtazinilyas/08-k8s-install-mia/blob/main/screenshots/test2.png)

Вывод команды `kubectl get pod -A`:

![get_pod_A](https://github.com/murtazinilyas/08-k8s-install-mia/blob/main/screenshots/get_po_A.png)

Вывод команды `kubectl nodes -o wide`:

![get_nodes_wide](https://github.com/murtazinilyas/08-k8s-install-mia/blob/main/screenshots/get_nodes_wide.png)