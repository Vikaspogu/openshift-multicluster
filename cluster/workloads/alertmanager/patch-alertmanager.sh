#!/usr/bin/env bash

set -o nounset
set -o errexit

if ! command -v jq &> /dev/null
then
    echo "jq could not be found... installing"
    JQ=/usr/bin/jq
    curl -L -o $JQ https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && chmod +x $JQ
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

echo $patchJson | envsubst > /tmp/alertmanager-patch.yaml

# Join
jq -s '.[0] * .[1]' /tmp/alertmanager.yaml $patchJson > /tmp/alertmanager-patch.yaml

# Set patched data
oc set data secret/alertmanager-main \
  -n openshift-monitoring --from-file /tmp/alertmanager-patch.yaml
