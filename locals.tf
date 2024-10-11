locals {
  cluster_ipv4 = [
    for ip in module.controller : ip.ipv4_address
  ]

  controller_mc = talos_machine_configuration_apply.controller
  main_controller_mc = local.controller_mc[keys(local.controller_mc)[0]]
}
