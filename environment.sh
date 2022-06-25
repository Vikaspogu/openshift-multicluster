#!/usr/bin/env bash

# shellcheck disable=SC2155
export REPO_ROOT=$(git rev-parse --show-toplevel)
export SECRETS_ENV="${REPO_ROOT}/.cluster-secrets.env"


# Ensure these cli utils exist
command -v kubectl >/dev/null 2>&1 || {
    echo >&2 "kubectl is not installed. Aborting."
    exit 1
}
command -v envsubst >/dev/null 2>&1 || {
    echo >&2 "envsubst is not installed. Aborting."
    exit 1
}
command -v yq >/dev/null 2>&1 || {
    echo >&2 "yq is not installed. Aborting."
    exit 1
}

# Check secrets env file exists
[ -f "${SECRETS_ENV}" ] || {
    echo >&2 "Secret enviroment file doesn't exist. Aborting."
    exit 1
}
# Check secrets env file is text (git-crypt has decrypted it)
file "${SECRETS_ENV}" | grep "ASCII text" >/dev/null 2>&1 || {
    echo >&2 "Secret enviroment file isn't a text file. Aborting."
    exit 1
}

# Export environment variables
set -a
. "${SECRETS_ENV}"
set +a
