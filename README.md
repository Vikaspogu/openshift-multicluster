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

Welcome to my OpenShift multi cluster Infrastructure as code repository

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

### GitOps

[OpenShift GitOps Operator](https://docs.openshift.com/container-platform/4.12/cicd/gitops/understanding-openshift-gitops.html) watches my [cluster](./kustomize/cluster-overlays/) folder (see Directories below) and makes the changes to my cluster based on the YAML manifests.

```bash
oc apply -k kustomize/bases/openshift-gitops-operator
cat ~/.config/sops/age/keys.txt | oc create secret generic sops-age -n openshift-gitops --from-file=keys.txt=/dev/stdin
oc apply -k kustomize/bases/openshift-gitops-config -n openshift-gitops
kustomize build kustomize/cluster-overlays/dev-acm/argo-application --enable-alpha-plugins --load-restrictor LoadRestrictionsNone | oc apply -f-
```

### Folder Layout

This Git repository contains the following directories (_kustomizatons_) under [cluster](./cluster/).

```sh
📁 helm                     # helm charts folder
├─📁 charts
├ └─ 📁 <CHART-NAME>        # custom helm charts
📁 kustomize                # openshift cluster defined as code
├─📁 bases                  # bases contains resources that applies to all clusters
└─📁 cluster-overlays       # Contains all the clusters managed by the repo
  └─ 📁 <CLUSTER-NAME>      # Contains applications to deploy on cluster, using helm/charts or kustomize/bases as resources
```

### Deploy Developer Hub

```bash
helm upgrade --install developer-hub openshift-helm-charts/redhat-developer-hub -f kustomize/cluster-overlays/dev-acm/developer-hub-chart/values.yaml -n=developer-hub --kube-insecure-skip-tls-verify
```

## 🔍 Features

- [x] ArgoCD with SOPS plugin
- [x] Secret Management using External secrets and 1Password
- [x] Cert manager for API and Wildcard certificate
- [x] Multi cluster management
- [x] Kyverno
- [x] Renovate bot

## :hammer: TODO

## Resources

- [Eth issue](https://forum.proxmox.com/threads/e1000e-unexpected-adapter-resets.89459/)
- [Proxmox helper scripts](https://tteck.github.io/Proxmox/)
- [GitOps Catalog by RedHat COP](https://github.com/redhat-cop/gitops-catalog)
