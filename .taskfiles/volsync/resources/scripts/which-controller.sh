#!/usr/bin/env bash

APP=$1
NAMESPACE="${2:-default}"

is_deployment() {
    kubectl --namespace "${NAMESPACE}" get deployment "${APP}" &>/dev/null
}

is_deploymentconfig() {
    kubectl --namespace "${NAMESPACE}" get deploymentconfig "${APP}" &>/dev/null
}

is_statefulset() {
    kubectl --namespace "${NAMESPACE}" get statefulset "${APP}" &>/dev/null
}

if is_deployment; then
    echo "deployment.apps/${APP}"
elif is_deploymentconfig; then
    echo "deploymentconfig.apps.openshift.io/${APP}"
elif is_statefulset; then
    echo "statefulset.apps/${APP}"
else
    echo "No deployment or statefulset found for ${APP}"
    exit 1
fi
