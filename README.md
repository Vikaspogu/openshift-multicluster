<!-- markdownlint-disable MD041 -->
<img src="https://avatars.githubusercontent.com/u/792337?s=280&v=4" align="left" width="144px" height="144px"/>

# OpenShift home cluster

_... managed by ArgoCD_ :robot:

<br/>
<br/>
<br/>

<div align="center">

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled?logo=pre-commit&logoColor=white&style=for-the-badge&color=brightgreen)](https://github.com/pre-commit/pre-commit)

</div>

---

## :wave: Overview

Welcome to my OpenShift operations repository

### Installing OpenShift cluster with Agent-based Installer

[Getting started](https://docs.openshift.com/container-platform/4.12/installing/installing_with_agent_based_installer/installing-with-agent-based-installer.html) on Agent-based installer

- Generate ISO

    ```bash
    rm -rf installer/pxm
    cp -r installer/cluster-config installer/pxm
    ./openshift-install agent create image --dir installer/pxm
    ```

- Upload ISO to proxmox
- Create 3 VMs
- Wait for the cluster to install

    ```bash
    export KUBECONFIG=installer/pxm/auth/kubeconfig
    ./openshift-install agent wait-for install-complete --dir installer/pxm --log-level=debug
    ```

### GitOps

[OpenShift GitOps Operator](https://docs.openshift.com/container-platform/4.12/cicd/gitops/understanding-openshift-gitops.html) watches my [cluster](./cluster/) folder (see Directories below) and makes the changes to my cluster based on the YAML manifests.

```bash
oc apply -k clusters/argo-bootstrap/operator
cat ~/.config/sops/age/keys.txt | oc create secret generic sops-age -n openshift-gitops --from-file=keys.txt=/dev/stdin
oc apply -k clusters/argo-bootstrap/instance
```

### Directories

This Git repository contains the following directories (_kustomizatons_) under [cluster](./cluster/).

```sh
📁 clusters                # openshift clusters defined as code
├─📁 bases                 # argo application set definition for workloads
├─📁 argo-bootstrap        # bootstrap operators and OpenShift GitOps operator
└─📁 cluster-overlays      # regular apps/operators
```

## 🔍 Features

- [X] Secret Management using Kustomize and SOPS
- [X] API and Wildcard certificate configuration using Argo Hooks
- [X] Renovate bot
- [X] Kyverno

## :hammer: TODO

## Resources

- [Eth issue](https://forum.proxmox.com/threads/e1000e-unexpected-adapter-resets.89459/)
- [Proxmox helper scripts](https://tteck.github.io/Proxmox/)
- [GitOps Catalog by RedHat COP](https://github.com/redhat-cop/gitops-catalog)
