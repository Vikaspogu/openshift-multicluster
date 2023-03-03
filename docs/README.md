# OpenShift on Proxmox

Tools used:

- [Ansible](https://www.ansible.com/)
- [Terraform](https://www.terraform.io/)
- [Proxmox](https://www.proxmox.com/en/)
- [mozilla/sops](https://toolkit.fluxcd.io/guides/mozilla-sops/): Manages secrets for OpenShift, Ansible and Terraform.
- [cert-manager](https://cert-manager.io/docs/): Creates SSL certificates for services in my OpenShift cluster.

## Install Proxmox

Installing proxmox is straightforward. Download boot ISO, flash to a USB, and complete the setup via GUI.

## Additional Storage

Once proxmox is installed, add additional storage choose `Datacenter` > `Storage` > `Add` > `LVM`

![Storage](./images/storage.png)

## Configure Proxmox

[Configuring proxmox](../provision/ansible/playbooks/proxmox-prepare.yml) using Ansible

Playbook does following:

- Install's dark theme
- Provision's terraform role, user, and access control
- Create's fedora cloud-init template for VMs

```bash
task ansible:prepare-proxmox
```

Install Edge kernel repos and dark theme

```bash
ssh proxmox
bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/edge-kernel.sh)"
bash <(curl -s https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/PVEDiscordDark.sh ) install

```

## Baremetal OpenShift installation

[Install Playbook](../provision/ansible/playbooks/openshift-install.yml) does following:

```bash
task ansible:openshift-install
```

For my setup I am using a fedora VM provisioned by [Terraform](../provision/terraform/proxmox/00-openshift-services-vm/) and Ansible [role](../provision/ansible/roles/openshift/) to configure Load balancer, NFS and PXE boot services. DNS is configured on Synology NAS.

For some reason I ran into issue while trying to create RHCOS VM's using Terraform, so i switched to `qm` commands to create, stop bootstrap, master, and worker VMs.

```bash
qm create ....
qm start <vm-id>
```

Once the VM's are provisioned, playbook with start the OpenShift installer process. wait for ControlPlane and MC to be active.

Lastly, It will wait for the bootstrap process to complete and approve any pending CSRs.

At this point, I have a running OpenShift cluster.

## Post Install

Next, I will use ansible to create critical config resources using [Post install Playbook](../provision/ansible/playbooks/openshift-post-install.yml) so ArgoCD can watch changes to my cluster folder.

```bash
task ansible:openshift-post-install
```

- Install cert-manager, openshift-gitops operator
- Update ArgoCD instance with ingress and KSOPS plugin

## ArgoCD

- Configure Oauth provider
- Configure cert-manager cluster-issuer object
- Create certificate's for APIServer and Ingress. Update certificates as postsync hook job

## Resources

- [Eth issue](https://forum.proxmox.com/threads/e1000e-unexpected-adapter-resets.89459/)
- [Proxmox helper scripts](https://tteck.github.io/Proxmox/)
- [Proxmox OCP playbooks](https://github.com/Keyvan-rh/Proxmox-OCP-Installer)
- [GitOps Catalog by RedHat COP](https://github.com/redhat-cop/gitops-catalog)

## NewRelic

Install newrelic, create a new account use helm installation method
