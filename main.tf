resource "yandex_kubernetes_cluster" "regional_cluster_resource_name" {
  name        = "k8s-cluster-regional-template-new"
  description = "k8s-cluster-regional-template-new"

  network_id = var.default_network_id

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = "ru-central1-a"
        subnet_id = var.default_subnet_id_zone_a
      }

      location {
        zone      = "ru-central1-b"
        subnet_id = var.default_subnet_id_zone_b
      }

      location {
        zone      = "ru-central1-c"
        subnet_id = var.default_subnet_id_zone_c
      }
    }

    version   = var.default_version_k8s_masters #version of the cluster
    public_ip = true 

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        day        = "monday"
        start_time = "15:00"
        duration   = "3h"
      }

      maintenance_window {
        day        = "friday"
        start_time = "10:00"
        duration   = "4h30m"
      }
    }
  }
  
  service_account_id      = var.default_service_account_id
  node_service_account_id = var.default_node_service_account_id
  release_channel = var.default_release_channel #type of release of the cluster
}


resource "yandex_kubernetes_node_group" "my_node_group" {
  cluster_id  = "${yandex_kubernetes_cluster.regional_cluster_resource_name.id}"
  name        = "k8s-cluster-regional-template-node-group-new"
  description = "k8s-cluster-regional-template-node-group-new"
  version     = var.default_version_k8s_node_group


  instance_template {
    platform_id = "standard-v3" #The ID of the hardware platform configuration for the node group compute instances

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false #VMs are preemptible or not
    }
  }

  scale_policy {
    auto_scale {
      min = 1
      max = 3
      initial = 3
    }
  }
 
  allocation_policy { #This argument specify subnets (zones), that will be used by node group compute instances. The structure is documented below.
    location {
      zone = var.default_zone
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}
