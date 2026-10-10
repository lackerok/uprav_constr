# 1. Создание трех виртуальных дисков по 1 Гб с использованием count
resource "yandex_compute_disk" "storage_disk" {
  count = 3

  name = "disk-${count.index + 1}"
  type = "network-hdd"
  zone = yandex_vpc_subnet.develop_d.zone
  size = 1
}

# 2. Создание одиночной ВМ storage с динамическим подключением secondary_disk
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v3"
  zone        = yandex_vpc_subnet.develop_d.zone

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-ssd"
      size     = 8
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk.*.id
    content {
      disk_id = secondary_disk.value
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_d.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_public_key}"
  }

  scheduling_policy {
    preemptible = true
  }
}
