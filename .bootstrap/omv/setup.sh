#!/bin/bash
export KUBECONFIG=./kubeconfig
oc apply -k ../../components/argocd-chart -n argocd-app
cat ~/.config/sops/age/keys.txt | oc create secret generic helm-secrets-private-keys -n argocd-app --from-file=keys.txt=/dev/stdin
oc create secret generic environment-variables -n argocd-app
oc apply -k .
