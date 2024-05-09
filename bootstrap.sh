#!/bin/bash
export KUBECONFIG=./kubeconfig
oc apply -k kustomize/bases/openshift-gitops-operator
sleep 60s
cat ~/.config/sops/age/keys.txt | oc create secret generic sops-age -n openshift-gitops --from-file=keys.txt=/dev/stdin
oc apply -k kustomize/bases/openshift-gitops-config -n openshift-gitops
kustomize build kustomize/cluster-overlays/dev-acm/argo-application --enable-alpha-plugins --load-restrictor LoadRestrictionsNone | oc apply -f-
