#!/usr/bin/env bash

set -o nounset
set -o errexit

YQ=/tmp/yq
ENVSUBST=/tmp/envsubst

if ! command -v $YQ &> /dev/null
then
    echo "yq could not be found... installing"
    curl -L -o $YQ https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && chmod +x $YQ
fi

if ! command -v $ENVSUBST &> /dev/null
then
    echo "envsubst could not be found... installing"
    curl -L -o $ENVSUBST https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-Linux-x86_64 && chmod +x $ENVSUBST
fi

patchJson='{
    "receivers": [
        {
            "name": "PagerDuty",
            "pagerduty_configs": [
                {
                    "severity": "critical",
                    "routing_key": "${WEBHOOK}"
                }
            ]
        }
    ]
}'

echo "Extract current alert manager config..."
oc extract secret/alertmanager-main --to /tmp/ -n openshift-monitoring --confirm

echo "Env substitute..."
echo $patchJson | $ENVSUBST | $YQ -p json -o yaml > /tmp/alertmanager-envsub.yaml

echo "YQ join files..."
#| $ENVSUBST Join
$YQ eval-all "select(fileIndex == 0) *n select(fileIndex == 1)" /tmp/alertmanager.yaml /tmp/alertmanager-envsub.yaml > /tmp/alertmanager-yq.yaml

mv /tmp/alertmanager-yq.yaml /tmp/alertmanager.yaml

echo "Setting secret data with new config..."
# Set patched data
oc set data secret/alertmanager-main \
  -n openshift-monitoring --from-file /tmp/alertmanager.yaml
