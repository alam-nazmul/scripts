variable "target_node" {
  type        = string
  default     = "pve"
  description = "Proxmox node where VMs will be created"
}

variable "clone_name" {
  type        = string
  default     = "Ubuntu20-CI-Template"
  description = "Template name which will be cloned to create VMs"
}

variable "storage" {
  type        = string
  default     = "local-lvm3"
  description = "Proxmox storage where VM disc will be created"
}

variable "ssh_keys" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCWAZ7GriZJ17cdS+63aX/858071RN4wgH5ghUY/hWgEXNXCka/iaa+bBMqeVfrpHPzyBRuZ14y2/GItOX37kh0ntLN2lopbpMIMh/6Oa6U2gH4AB+WgtZl4dYhF7xBaiYDRCLGJQ7sHuSZFG4m0bIwduNsWG2ejt8JDFwht0DtsD/O09fXQjTPI1uQnoVcX885OT7WETEz05vHmxa0zWr+rGwkUYosZ9S0PtVdIgMc4pCf1lBF6/6dnGzGKmwoJwZnh0lTDc/Ja9McaPJ1ViJLDM4bra+6k5ObuwH+49TlzbN9quWsy0W6RybICFhL0QyIJX7XJqygqTJ5sTViC1QyFkGGfyr1R9D59l+pDSWglmSlWfuhRvhPoDxmJcg24Rw+k57LHz4F5Vjcz++z2Zqb3wVzu50eJRzh0mACcKO/ndEsrXGLKJUzFqQJ8JkdZmMg+fTELLB3JQaA2qnRy7mSVY9XrDjcUTsVhhxAmAwZas/FMWV0mElWfv8I3tWL86E= nazmul@prod-test"
  description = "ssh-keys for host machine"
}

variable "vm" {
  type = list(object({
    name     = string
    vmid     = number
    core     = number
    socket   = number
    memory   = number
    hdd-size = string
    ip       = string
  }))

  default = [
    {
      name     = "ib-iat-db-redis-ubuntu"
      vmid     = 501
      core     = 2
      socket   = 1
      memory   = 2 * 1024
      hdd-size = "20G"
      ip       = "ip=172.16.7.201/22,gw=172.16.4.1"
    },
    {
      name     = "ib-iat-auth-services-ubuntu"
      vmid     = 502
      core     = 2
      socket   = 1
      memory   = 2 * 1024
      hdd-size = "20G"
      ip       = "ip=172.16.7.202/22,gw=172.16.4.1"
    },
    {
      name     = "ib-iat-ib-api-ubuntu"
      vmid     = 503
      core     = 2
      socket   = 1
      memory   = 2 * 1024
      hdd-size = "20G"
      ip       = "ip=172.16.7.203/22,gw=172.16.4.1"
    },
    {
      name     = "ib-iat-helper-services-ubuntu"
      vmid     = 504
      core     = 2
      socket   = 1
      memory   = 2 * 1024
      hdd-size = "20G"
      ip       = "ip=172.16.7.204/22,gw=172.16.4.1"
    },
    {
      name     = "ib-iat-web-portals-ubuntu"
      vmid     = 505
      core     = 2
      socket   = 1
      memory   = 2 * 1024
      hdd-size = "20G"
      ip       = "ip=172.16.7.205/22,gw=172.16.4.1"
    },
    {
      name     = "ib-iat-drws-containers-ubuntu"
      vmid     = 506
      core     = 2
      socket   = 1
      memory   = 2 * 1024
      hdd-size = "20G"
      ip       = "ip=172.16.7.206/22,gw=172.16.4.1"
    },
    {
      name     = "ib-iat-cbs-middleware-ubuntu"
      vmid     = 507
      core     = 2
      socket   = 1
      memory   = 2 * 1024
      hdd-size = "20G"
      ip       = "ip=172.16.7.207/22,gw=172.16.4.1"
    },
    {
      name     = "ib-iat-cbs-middleware-gateway-ubuntu"
      vmid     = 508
      core     = 2
      socket   = 1
      memory   = 2 * 1024
      hdd-size = "20G"
      ip       = "ip=172.16.7.208/22,gw=172.16.4.1"
    },
    {
      name     = "ib-iat-cbs-middleware-db-redis-ubuntu"
      vmid     = 509
      core     = 2
      socket   = 1
      memory   = 2 * 1024
      hdd-size = "20G"
      ip       = "ip=172.16.7.209/22,gw=172.16.4.1"
    }    
  ]
}