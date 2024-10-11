module "worker" {
  for_each = var.worker

  source = "../terraform-proxmox-vm"

  datastore_id = var.proxmox_storage

  name      = each.key
  node_name = var.proxmox_nodename

  cpu_units = 512

  cores  = each.value.cpu
  memory = each.value.mem

  disk_size    = each.value.disk
  disk_file_id = var.proxmox_image
}

resource "cloudflare_record" "worker" {
  for_each = module.worker

  zone_id = var.cloudflare_zone_id
  name    = "${each.value.name}.${var.kubernetes.apiDomain}"
  value   = each.value.ipv4_address
  type    = "A"
}
