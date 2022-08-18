terraform {

  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.11"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.1"
    }
  }
}

data "sops_file" "proxmox_secrets" {
  source_file = "../../secret.sops.yaml"
}

provider "proxmox" {
  pm_api_url      = data.sops_file.proxmox_secrets.data["pm_api_url"]
  pm_user         = data.sops_file.proxmox_secrets.data["pm_username"]
  pm_password     = data.sops_file.proxmox_secrets.data["pm_password"]
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "k8s-7-proxmox-node" {
  count       = 1
  name        = "k8s-7-proxmox-node"
  target_node = var.pm_node

  clone = "ubuntu-2004-cloudinit-template"

  os_type  = "cloud-init"
  cores    = 8
  sockets  = "1"
  cpu      = "host"
  memory   = 16384
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    size     = "64G"
    type     = "scsi"
    storage  = "raid-hhd-vg"
    iothread = true
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # cloud-init settings
  # adjust the ip and gateway addresses as needed
  ipconfig0 = "ip=${data.sops_file.proxmox_secrets.data["k8s_7_ip"]}/24,gw=${data.sops_file.proxmox_secrets.data["gw_ip"]}"
  ssh_user  = data.sops_file.proxmox_secrets.data["ssh_user"]
  sshkeys   = file(var.ssh_keys["pub"])
  ciuser    = data.sops_file.proxmox_secrets.data["ssh_user"]
}
