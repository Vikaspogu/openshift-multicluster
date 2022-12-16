#!/usr/bin/env bash

set -o nounset
set -o errexit

YQ=/tmp/yq
ENVSUBST=/tmp/envsubst

if ! command -v $YQ &> /dev/null
then
    echo "jq could not be found... installing"
    curl -L -o $YQ https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && chmod +x $YQ
fi

if ! command -v $ENVSUBST &> /dev/null
then
    echo "envsubst could not be found... installing"
    curl -L -o $ENVSUBST https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-Linux-x86_64 && chmod +x $ENVSUBST
fi

patchYaml="
receivers:
- name: PagerDuty
  pagerduty_configs:
  - severity: critical
    routing_key: haghsghwjgakjkjhk
"

echo "Extract current alert manager config..."
oc extract secret/alertmanager-main --to /tmp/ -n openshift-monitoring --confirm

cat /tmp/alertmanager.yaml
echo "Env substitute..."
echo $patchJson | $ENVSUBST > /tmp/alertmanager-envsub.yaml

cat /tmp/alertmanager-envsub.yaml

echo "YQ join files..."
# Join
$YQ eval-all '. as $item ireduce ({}; . * $item)' /tmp/alertmanager.yaml /tmp/alertmanager-envsub.yaml > /tmp/alertmanager-patch.yaml

echo "Setting secret data with new config..."
# Set patched data
oc set data secret/alertmanager-main \
  -n openshift-monitoring --from-file /tmp/alertmanager-patch.yaml
