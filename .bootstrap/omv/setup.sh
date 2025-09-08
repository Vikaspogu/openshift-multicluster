#!/bin/bash
export KUBECONFIG=./kubeconfig
oc apply -k ../../components/argocd-chart -n argo-system
cat ~/.config/sops/age/keys.txt | oc create secret generic helm-secrets-private-keys -n argo-system --from-file=keys.txt=/dev/stdin
oc create secret generic environment-variables -n argo-system
oc apply -k .
