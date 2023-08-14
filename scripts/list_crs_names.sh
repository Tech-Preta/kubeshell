#!/bin/bash

# Obtém a lista de CRDs no cluster
crds=$(kubectl get crd -o jsonpath='{.items[*].metadata.name}')

# Loop pelos CRDs
for crd in $crds; do
    crd_version=$(kubectl get crd "$crd" -o jsonpath='{.spec.versions[0].name}')
    echo "CRD: $crd (Version: $crd_version)"
done
