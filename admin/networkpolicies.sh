#!/bin/bash

# Verifica se o kubectl está instalado
kubectl_installed=$(command -v kubectl)

if [ -z "$kubectl_installed" ]; then
    echo "O kubectl não está instalado no seu sistema."
else
    echo "Verificando NetworkPolicies aplicadas no cluster:"
    echo "-----------------------------------------"

    # Obtém a lista de namespaces
    namespaces=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')

    # Loop pelos namespaces
    for ns in $namespaces; do
        echo "Namespace: $ns"
        echo "-----------------------------------------"

        # Obtém a lista de NetworkPolicies no namespace
        networkpolicies=$(kubectl get networkpolicies -n "$ns" -o jsonpath='{.items[*].metadata.name}' 2>/dev/null)

        if [ -z "$networkpolicies" ]; then
            echo "Nenhuma NetworkPolicy encontrada neste namespace."
        else
            for np in $networkpolicies; do
                echo "NetworkPolicy: $np"
            done
        fi

        echo
    done
fi
