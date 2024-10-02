#!/usr/bin/env bash
set -o errexit
set -o pipefail

CLUSTER_DIR=$1

[[ -z "${CLUSTER_DIR}" ]] && echo "Kubernetes location not specified" && exit 1

kustomize_args=("--load-restrictor=LoadRestrictionsNone")
kustomize_config="kustomization.yaml"
kubeconform_args=(
    "-strict"
    "-ignore-missing-schemas"
    "-skip"
    "Secret"
    "-schema-location"
    "default"
    "-schema-location"
    "https://kubernetes-schemas.pages.dev/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json"
    "-verbose"
)

echo "=== Validating kustomizations in ${CLUSTER_DIR} ==="
find "${CLUSTER_DIR}" -type f -name $kustomize_config -print0 | while IFS= read -r -d $'\0' file;
  do
    if [[ ${file/%$kustomize_config} != *"onepassword-connect-chart"* ]]; then
      echo "=== Validating kustomizations in ${file/%$kustomize_config} ==="
      kustomize build --enable-alpha-plugins --enable-exec --load-restrictor=LoadRestrictionsNone "${file/%$kustomize_config}" "${kustomize_args[@]}" | \
        kubeconform "${kubeconform_args[@]}"
      if [[ ${PIPESTATUS[0]} != 0 ]]; then
        exit 1
      fi
    fi
done
