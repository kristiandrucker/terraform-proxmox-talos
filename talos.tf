resource "talos_machine_secrets" "secrets" {}

data "talos_machine_configuration" "controller" {
  for_each = module.controller

  depends_on = [
    cloudflare_record.controller-vip
  ]

  cluster_name     = var.kubernetes.clusterName
  cluster_endpoint = "https://${var.kubernetes.apiDomain}:6443"
  machine_secrets  = talos_machine_secrets.secrets.machine_secrets
  machine_type     = "controlplane"

  kubernetes_version = var.kubernetes.kubernetesVersion
  talos_version = var.kubernetes.talosVersion
  docs = false
  examples = false
  config_patches = [
    templatefile("${path.module}/templates/controlplane.yaml.tpl",
      merge({}, {
        podSubnets = var.kubernetes.podSubnets
        serviceSubnets = var.kubernetes.serviceSubnets
        talos-version = var.kubernetes.talosVersion
        clusterDomain = var.kubernetes.clusterDomain
        cluster_vip = var.kubernetes.clusterVIP

        hostname = "${each.value.name}.${var.kubernetes.apiDomain}"
        ipv4_local = each.value.ipv4_address
        apiDomain = var.kubernetes.apiDomain
        px_region = var.region
        px_node = var.proxmox_nodename
      })
    )]
}

data "talos_machine_configuration" "worker" {
  for_each = module.worker

  depends_on = [
    cloudflare_record.controller-vip
  ]

  cluster_name     = "lab"
  cluster_endpoint = "https://${var.kubernetes.apiDomain}:6443"
  machine_secrets  = talos_machine_secrets.secrets.machine_secrets
  machine_type     = "worker"

  kubernetes_version = var.kubernetes.kubernetesVersion
  talos_version = var.kubernetes.talosVersion
  docs = false
  examples = false
  config_patches = [
    templatefile("${path.module}/templates/worker.yaml.tpl", {
        podSubnets = var.kubernetes.podSubnets
        serviceSubnets = var.kubernetes.serviceSubnets
        talos-version = var.kubernetes.talosVersion
        clusterDomain = var.kubernetes.clusterDomain
        cluster_vip = var.kubernetes.clusterVIP

        hostname = "${each.value.name}.${var.kubernetes.apiDomain}"
        ipv4_local = each.value.ipv4_address
        apiDomain = var.kubernetes.apiDomain
        px_region = var.region
        px_node = var.proxmox_nodename
      }
    )]
}

data "talos_client_configuration" "this" {
  cluster_name         = var.kubernetes.clusterName
  client_configuration = talos_machine_secrets.secrets.client_configuration
  nodes = local.cluster_ipv4
  endpoints = local.cluster_ipv4
}

resource "talos_machine_configuration_apply" "controller" {
  for_each = module.controller

  client_configuration        = talos_machine_secrets.secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controller[each.key].machine_configuration
  node                        = each.value.ipv4_address
}

resource "talos_machine_configuration_apply" "worker" {
  for_each = module.worker

  client_configuration        = talos_machine_secrets.secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker[each.key].machine_configuration
  node                        = each.value.ipv4_address
}

resource "talos_machine_bootstrap" "controller" {
  client_configuration = local.main_controller_mc.client_configuration
  node                 = local.main_controller_mc.node
}

data "talos_cluster_kubeconfig" "this" {
  depends_on = [
    talos_machine_bootstrap.controller
  ]

  client_configuration = local.main_controller_mc.client_configuration
  node                 = local.main_controller_mc.node
}
