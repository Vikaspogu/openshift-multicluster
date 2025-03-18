<!-- markdownlint-disable MD041 -->

<img src="https://avatars.githubusercontent.com/u/792337?s=280&v=4" align="left" width="45" height="47"/><h1>&nbsp;&nbsp;Multi-Cluster OpenShift Management with ArgoCD</h1>

_... managed by ArgoCD_ <img src="https://redhat-scholars.github.io/argocd-tutorial/argocd-tutorial/_images/argocd-logo.png" align="center" width="40px" height="40px"/>

---

## :wave: Overview

This repository provides the necessary files and instructions to manage multiple OpenShift clusters using ArgoCD and GitOps principles. This setup allows for consistent, repeatable, and automated configuration of your OpenShift environments. This repository follows standards from [gitops-standards-repo-template](https://github.com/redhat-cop/gitops-standards-repo-template.git)

## Table of Contents

1. [Installation of OpenShift cluster](#installing-openshift-cluster-with-agent-based-installer)
2. [Bootstrap Argocd instance](#bootstrap-argocd-instance)
3. [Repository Structure](https://github.com/redhat-cop/gitops-standards-repo-template?tab=readme-ov-file#repo-structure)
4. [ArgoCD Plugins](#argocd-plugins-and-usage)

### Installing OpenShift cluster with Agent-based Installer

[Getting started](https://docs.openshift.com/container-platform/4.12/installing/installing_with_agent_based_installer/installing-with-agent-based-installer.html) on Agent-based installer

#### Manual Steps

- Generate ISO

  ```bash
  rm -rf installer/proxmox #remove older cluster if any
  cp -r installer/cluster installer/proxmox #copy cluster config files
  ./openshift-install agent create image --dir installer/proxmox #create image
  ```

- Upload ISO to proxmox from GUI
- Create 3 VMs with CPU type as `max`
- Start VMs and wait for the cluster installation to finish

  ```bash
  export KUBECONFIG=installer/proxmox/auth/kubeconfig
  ./openshift-install agent wait-for install-complete --dir installer/proxmox --log-level=debug
  ```

#### Ansible workflow to deploy OpenShift cluster

[Workflow](https://github.com/Vikaspogu/homelab-orchestrator/blob/main/ansible/awx/workflows/openshift-cluster.yaml) to automate manual steps described above

## Bootstrap ArgoCD instance

### Manual

```bash
oc login
./.bootstrap/setup.sh
```

### Automated

[Playbook](https://github.com/Vikaspogu/homelab-orchestrator/blob/main/ansible/playbooks/openshift/acm-gitops-bootstrap.yaml) to automate manual steps described above

## ArgoCD Plugins and Usage

Below are the list of plugins used in this Repository

- [ArgoCD Lovely Plugin](https://github.com/crumbhole/argocd-lovely-plugin/tree/main)
- [Custom Plugins](./components/openshift-gitops-config/)

### ArgoCD Lovely Plugin

ArgoCD Lovely Plugin facilitates the management of Kustomize patches and environment variable substitutions within the ArgoCD application specification.

- [Patching Operator Channel in Helm values](./clusters/proxmox/cert-manager.yaml#L15)
- [Kustomize Patch](./clusters/proxmox/metallb.yaml#L34)
- [Using sed to replace variable in all yaml files](./clusters/proxmox/cert-manager.yaml#L28)
- [Using yq to replace variable in single yaml file](./clusters/proxmox/acm.yaml#13)

## 🔍 Features

- [x] ArgoCD with SOPS plugin
- [x] Secret Management using External secrets and 1Password
- [x] Cert manager integration with Cloudflare for API and Wildcard certificate
- [x] Multi cluster management using Red Hat ACM
- [x] OpenShift Pipeline as Code
- [x] Renovate bot

## Resources

- [GitOps Catalog by RedHat COP](https://github.com/redhat-cop/gitops-catalog)
