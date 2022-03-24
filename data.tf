data "yandex_kubernetes_cluster" "regional_cluster_resource_name" {
  cluster_id = "${yandex_kubernetes_cluster.regional_cluster_resource_name.id}"
}
