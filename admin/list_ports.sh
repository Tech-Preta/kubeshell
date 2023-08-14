#!/bin/bash

# Define a função para obter informações das portas de um serviço
get_service_ports() {
    local namespace=$1
    local service_name=$2
    kubectl get svc "$service_name" -n "$namespace" -o json | \
    jq -r '.spec.ports[] | "\(.port) -> \(.nodePort)"'
}

# Obtém todos os namespaces no cluster
namespaces=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')

# Loop pelos namespaces
for ns in $namespaces; do
    echo "Namespace: $ns"
    echo "-----------------------------------------"
    
    # Obtém todos os serviços no namespace
    services=$(kubectl get svc -n "$ns" -o jsonpath='{.items[*].metadata.name}')
    
    # Loop pelos serviços
    for svc in $services; do
        echo "Serviço: $svc"
        get_service_ports "$ns" "$svc"
        echo "-----------------------------------------"
    done
    
    echo
done
