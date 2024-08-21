#!/bin/sh
if [[ "$(oc get csr $1 "to be approved" ]]; then
    oc adm certificate approve $1
fi
