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

resource "proxmox_vm_qemu" "openshift-services" {
  count       = var.vm_count
  name        = "openshift-services"
  target_node = var.pm_node

  clone = "ubuntu-2004-cloudinit-template"

  os_type  = "cloud-init"
  cores    = 4
  sockets  = "1"
  cpu      = "host"
  memory   = 8102
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"
  onboot   = true

  disk {
    size    = "1000G"
    type    = "scsi"
    storage = "lvm-thin-raid"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # cloud-init settings
  # adjust the ip and gateway addresses as needed
  ipconfig0 = "ip=${data.sops_file.proxmox_secrets.data["openshift_service_ip"]}/24,gw=${data.sops_file.proxmox_secrets.data["gw_ip"]}"
  ssh_user  = data.sops_file.proxmox_secrets.data["ssh_user"]
  sshkeys   = file(var.ssh_keys["pub"])
  ciuser    = data.sops_file.proxmox_secrets.data["ssh_user"]

  # defines ssh connection to check when the VM is ready for ansible provisioning
  connection {
    host        = data.sops_file.proxmox_secrets.data["openshift_service_ip"]
    user        = data.sops_file.proxmox_secrets.data["ssh_user"]
    private_key = file(var.ssh_keys["priv"])
    agent       = false
    timeout     = "3m"
  }

  provisioner "remote-exec" {
    inline = ["echo 'Ready for ansible provisioning...'"]
  }

  provisioner "local-exec" {
    working_dir = "../../../ansible/playbooks"
    command     = "ansible-playbook -u ${data.sops_file.proxmox_secrets.data["ssh_user"]} --key-file ${var.ssh_keys["priv"]} -i ${data.sops_file.proxmox_secrets.data["openshift_service_ip"]}, openshift-services-vm-prepare.yml"
  }

}
