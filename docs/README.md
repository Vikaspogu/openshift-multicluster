# Provision

## Additional LVM Storage

To add additional storage choose `Datacenter` > `Storage` > `Add` > `LVM`

![Storage](./images/storage.png)

## Run provision playbook

[Provision playbook](../provision/ansible/playbooks/proxmox-prepare.yml)

* Dark theme
* Terraform role, user and access control
* Create ubuntu cloud init template
* Enable correct proxmox repositories
* Disable nag

```bash
task ansible:prepare-proxmox
```

## 00 VMs

* k8s node

```bash
task terraform:proxmox-apply DIR=provision/terraform/proxmox/00-vm
```

## Deploy OCP4

* Provision OCP4 Service node - Haproxy, PXE, NFS
* Create bootstrap, master and worker VMs

```bash
task ansible:ocp4-install
```

## Post Deploy OCP4

* Provision OCP4 Service node - Haproxy, PXE, NFS
* Create bootstrap, master and worker VMs

```bash
task ansible:ocp4-post-install
```

## Resources

* [Eth issue](https://forum.proxmox.com/threads/e1000e-unexpected-adapter-resets.89459/)
* [Proxmox helper scripts](https://tteck.github.io/Proxmox/)
* [Proxmox OCP playbooks](https://github.com/Keyvan-rh/Proxmox-OCP-Installer)
