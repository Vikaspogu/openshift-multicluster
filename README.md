<!-- markdownlint-disable MD041 -->

<img src="https://avatars.githubusercontent.com/u/792337?s=280&v=4" align="left" width="45" height="45"/><h1>&nbsp;&nbsp;Multi-Cluster OpenShift Management with ArgoCD</h1>

_... managed by ArgoCD_ <img src="https://redhat-scholars.github.io/argocd-tutorial/argocd-tutorial/_images/argocd-logo.png" align="center" width="40px" height="40px"/>

---

## :wave: Overview

This repository provides the necessary files and instructions to manage multiple OpenShift clusters using ArgoCD and GitOps principles. This setup allows for consistent, repeatable, and automated configuration of your OpenShift environments. This repository follows standards from [gitops-standards-repo-template](https://github.com/redhat-cop/gitops-standards-repo-template.git)

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

- [GitOps Catalog by RedHat COP](https://github.com/redhat-cop/gitops-catalog)
