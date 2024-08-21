#!/bin/bash
export KUBECONFIG=./kubeconfig
oc apply -k ../components/openshift-gitops-operator
sleep 60s
cat ~/.config/sops/age/keys.txt | oc create secret generic sops-age -n openshift-gitops --from-file=keys.txt=/dev/stdin
oc apply -k . -n openshift-gitops
