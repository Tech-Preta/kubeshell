#!/bin/bash

# Obtém a lista de CRDs no cluster
crds=$(kubectl get crd -o jsonpath='{.items[*].metadata.name}')

# Loop pelos CRDs
for crd in $crds; do
    echo "CRD: $crd"
    echo "-----------------------------------------"
    
    # Obtém detalhes do CRD
    kubectl get crd "$crd" -o yaml
    
    echo "-----------------------------------------"
    echo
done
