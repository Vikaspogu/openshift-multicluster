<!-- markdownlint-disable MD041 -->
<img src="https://avatars.githubusercontent.com/u/792337?s=280&v=4" align="left" width="144px" height="144px"/>

# OpenShift Multi-cluster IaC

_... managed by ArgoCD_ :robot:

<br/>
<br/>
<br/>

<div align="center">

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled?logo=pre-commit&logoColor=white&style=for-the-badge&color=brightgreen)](https://github.com/pre-commit/pre-commit)

</div>

---

## :wave: Overview

Welcome to my OpenShift multi cluster Infrastructure as code repository. This repository follows standards from [gitops-standards-repo-template](https://github.com/redhat-cop/gitops-standards-repo-template.git)

### Installing OpenShift cluster with Agent-based Installer

[Getting started](https://docs.openshift.com/container-platform/4.12/installing/installing_with_agent_based_installer/installing-with-agent-based-installer.html) on Agent-based installer

#### Manual Steps

- Generate ISO

  ```bash
  rm -rf installer/dev-acm #remove older cluster if any
  cp -r installer/cluster installer/dev-acm #copy cluster config files
  ./openshift-install agent create image --dir installer/dev-acm #create image
  ```

- Upload ISO to proxmox from GUI
- Create 3 VMs with CPU type as `max`
- Start VMs and wait for the cluster installation to finish

  ```bash
  export KUBECONFIG=installer/dev-acm/auth/kubeconfig
  ./openshift-install agent wait-for install-complete --dir installer/dev-acm --log-level=debug
  ```

#### Automation

[Playbooks](https://github.com/Vikaspogu/aap-playbooks) to automate manual steps described above

## 🔍 Features

- [x] ArgoCD with SOPS plugin
- [x] Secret Management using External secrets and 1Password
- [x] Cert manager for API and Wildcard certificate
- [x] Multi cluster management
- [x] OpenShift Pipeline as Code 
- [x] Kyverno
- [x] Renovate bot

## Resources

- [Proxmox helper scripts]([https://tteck.github.io/Proxmox/](https://community-scripts.github.io/ProxmoxVE/))
- [GitOps Catalog by RedHat COP](https://github.com/redhat-cop/gitops-catalog)
