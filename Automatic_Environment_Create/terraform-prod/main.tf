resource "proxmox_vm_qemu" "ib_vms" {
  count       = length(var.vm)
  name        = var.vm[count.index].name
  vmid        = var.vm[count.index].vmid
  target_node = var.target_node
  clone       = var.clone_name
  full_clone  = true
  onboot      = true
  oncreate    = false
  agent       = 1
  cores       = var.vm[count.index].core
  sockets     = var.vm[count.index].socket
  memory      = var.vm[count.index].memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  disk {
    slot    = 0
    size    = var.vm[count.index].hdd-size
    type    = "scsi"
    storage = var.storage
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = var.vm[count.index].ip
  sshkeys   = var.ssh_keys
}