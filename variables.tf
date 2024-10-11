variable "proxmox_nodename" {
  description = "Proxmox node name"
  type        = string
}

variable "proxmox_image" {
  description = "Proxmox source image name"
  type        = string
  default     = "talos"
}

variable "proxmox_storage" {
  description = "Proxmox storage name"
  type        = string
}

variable "region" {
  description = "Proxmox Cluster Name"
  type        = string
  default     = "cluster-1"
}

variable "cloudflare_zone_id" {
  type = string
}

variable "kubernetes" {
  type = object({
    kubernetesVersion : string,
    talosVersion : string,
    podSubnets : string,
    serviceSubnets : string,
    clusterVIP : string,
    clusterDomain : string,
    apiDomain : string,
    clusterName : string,
  })
  default = {
    kubernetesVersion = "v1.30.1"
    talosVersion      = "v1.7.2"
    podSubnets        = "10.244.0.0/16"
    serviceSubnets    = "10.96.0.0/12"
    clusterVIP        = "10.1.0.3"
    clusterDomain     = "cluster.local"
    apiDomain         = "api.cluster.local"
    clusterName       = "talos-k8s-proxmox"
  }
}

variable "controller" {
  description = "Property of K8s controller nodes"
  type        = map(
    object({
      cpu : number,
      mem : number,
      disk : number,
    })
  )
  default = {
    "node1" = {
      cpu  = 2,
      mem  = 4096,
      disk = 32,
    },
    "node2" = {
      cpu  = 2,
      mem  = 4096,
      disk = 32,
    }
  }
}

variable "worker" {
  description = "Property of K8s worker nodes"
  type        = map(
    object({
      cpu : number,
      mem : number,
      disk : number,
    })
  )
  default = {
    "node1" = {
      cpu  = 2,
      mem  = 4096,
      disk = 32,
    },
    "node2" = {
      cpu  = 2,
      mem  = 4096,
      disk = 32,
    }
  }
}

variable "instances" {
  description = "Map of VMs launched on proxmox hosts"
  type        = map(any)
  default = {
    "all" = {
      version = "v1.28.2"
    },
    "node1" = {
      web_id       = 1000
      web_count    = 0,
      web_cpu      = 2,
      web_mem      = 4096,
      web_ip0      = "", # ip=dhcp,ip6=dhcp
      worker_id    = 1050
      worker_count = 0,
      worker_cpu   = 2,
      worker_mem   = 4096,
      worker_ip0   = "", # ip=dhcp,ip6=dhcp
    },
    "node2" = {
      web_id       = 2000
      web_count    = 0,
      web_cpu      = 2,
      web_mem      = 4096,
      worker_id    = 2050
      worker_count = 0,
      worker_cpu   = 2,
      worker_mem   = 4096,
    }
    "node3" = {
      web_id       = 3000
      web_count    = 0,
      web_cpu      = 2,
      web_mem      = 4096,
      worker_id    = 3050
      worker_count = 0,
      worker_cpu   = 2,
      worker_mem   = 4096,
    }
  }
}
