#!/bin/bash

# Verifica se há storageclasses no cluster
storageclasses=$(kubectl get storageclasses -o jsonpath='{.items[*].metadata.name}' 2>/dev/null)

if [ -z "$storageclasses" ]; then
    echo "Não foram encontradas StorageClasses no cluster."
else
    echo "StorageClasses encontradas no cluster:"
    echo "-----------------------------------------"
    
    default_storageclass=$(kubectl get storageclass --all-namespaces -o jsonpath='{.items[?(@.metadata.annotations.storageclass\.kubernetes\.io/is-default-class=="true")].metadata.name}')
    
    for sc in $storageclasses; do
        if [ "$sc" == "$default_storageclass" ]; then
            echo "Nome: $sc (Padrão)"
        else
            echo "Nome: $sc"
        fi
    done
fi
