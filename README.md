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

Welcome to my OpenShift operations repository.

For more information, head on over to my [docs](./docs/README.md).

### GitOps

[OpenShift GitOps Operator](https://docs.openshift.com/container-platform/4.11/cicd/gitops/understanding-openshift-gitops.html) watches my [cluster](./cluster/) folder (see Directories below) and makes the changes to my cluster based on the YAML manifests.

### Directories

This Git repository contains the following directories (_kustomizatons_) under [cluster](./cluster/).

```sh
📁 cluster      # openshift cluster defined as code
├─📁 config     # cluster config, loaded before 📁 core and 📁 apps
├─📁 core       # crucial apps, namespaced dir tree, loaded before 📁 apps
└─📁 apps       # regular apps, namespaced dir tree, loaded last
```

## 🔍 Features

- [X] Secret Management using Kustomise and SOPS
- [X] API and Wildcard certificate configuration using Argo Hooks

## :hammer: TODO

- [ ] cloudfared tunnel
