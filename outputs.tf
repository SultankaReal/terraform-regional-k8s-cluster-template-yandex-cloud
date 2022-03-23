output "version_info" {
  value = "${yandex_kubernetes_cluster.regional_cluster_resource_name.master.0.version_info}"
  description = "Information about cluster version"
}

output "public_ip_of_k8s_cluster_master" {
  value = "${yandex_kubernetes_cluster.regional_cluster_resource_name.master.0.external_v4_address}"
  description = "The public ip of k8s cluster (master)"
}
