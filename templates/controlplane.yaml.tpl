machine:
  nodeLabels:
    node.cloudprovider.kubernetes.io/platform: proxmox
    topology.kubernetes.io/region: ${px_region}
    topology.kubernetes.io/zone: ${px_node}
    feature.node.kubernetes.io/system-os_release.ID: talos
  certSANs:
    - 127.0.0.1
    - ${apiDomain}
    - ${ipv4_local}
  kubelet:
    defaultRuntimeSeccompProfileEnabled: true
    disableManifestsDirectory: true
    extraArgs:
      rotate-server-certificates: "true"
    nodeIP:
      validSubnets:
        - 10.1.0.0/24
  network:
    hostname: "${hostname}"
    interfaces:
      - interface: eth0
        dhcp: true
        vip:
          ip: ${cluster_vip}
  sysctls:
    fs.inotify.max_queued_events: "65536"
    fs.inotify.max_user_instances: "8192"
    fs.inotify.max_user_watches: "524288"
    net.core.rmem_max: "2500000"
    net.core.wmem_max: "2500000"
  time:
    servers:
      - time.cloudflare.com
  features:
    rbac: true
    stableHostname: true
    apidCheckExtKeyUsage: true
    kubernetesTalosAPIAccess:
      enabled: true
      allowedRoles:
        - os:admin
      allowedKubernetesNamespaces:
        - system-upgrade
    hostDNS:
      enabled: true
      resolveMemberNames: true
  kernel:
    modules:
      - name: br_netfilter
        parameters:
          - nf_conntrack_max=131072
cluster:
  controlPlane:
    endpoint: https://${cluster_vip}:6443
  network:
    cni:
      name: none
    dnsDomain: ${clusterDomain}
    podSubnets: [ ${podSubnets} ]
    serviceSubnets: [ ${serviceSubnets} ]
  coreDNS:
    disabled: true
  proxy:
    disabled: true
  apiServer:
    certSANs:
      - 127.0.0.1
      - ${cluster_vip}
  etcd:
    extraArgs:
      listen-metrics-urls: http://0.0.0.0:2381
  discovery:
    enabled: true
    registries:
        kubernetes:
            disabled: false
        service:
            disabled: false
