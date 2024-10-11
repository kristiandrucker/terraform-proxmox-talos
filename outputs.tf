output "controllers" {
  value = module.controller
}

output "workers" {
  value = module.worker
}

output "controller_ips" {
  value = local.cluster_ipv4
}

output "talos_config" {
  value = data.talos_client_configuration.this.talos_config
  sensitive = true
}

output "kube_config" {
  value = data.talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}
