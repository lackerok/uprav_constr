data "yandex_vpc_network" "develop" {
  name = "develop"
}

resource "yandex_vpc_subnet" "develop_a" {
  name           = "develop-a"
  zone           = "ru-central1-a"
  network_id     = data.yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

resource "yandex_vpc_subnet" "develop_d" {
  name           = "develop-d"
  zone           = "ru-central1-d"
  network_id     = data.yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.3.0/24"]
}
