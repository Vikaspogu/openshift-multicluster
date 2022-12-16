#!/usr/bin/env bash

set -o nounset
set -o errexit

JQ=/tmp/jq
ENVSUBST=/tmp/envsubst

if ! command -v $JQ &> /dev/null
then
    echo "jq could not be found... installing"
    curl -L -o $JQ https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && chmod +x $JQ
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

oc extract secret/alertmanager-main --to /tmp/ -n openshift-monitoring --confirm

echo $patchJson | $ENVSUBST > /tmp/alertmanager-envsub.yaml

# Join
$JQ -s '.[0] * .[1]' /tmp/alertmanager.yaml /tmp/alertmanager-envsub.yaml > /tmp/alertmanager-patch.yaml

# Set patched data
oc set data secret/alertmanager-main \
  -n openshift-monitoring --from-file /tmp/alertmanager-patch.yaml
