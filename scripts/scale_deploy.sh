#!/bin/bash

# Verifica se o kubectl está instalado
kubectl_installed=$(command -v kubectl)

if [ -z "$kubectl_installed" ]; then
    echo "O kubectl não está instalado no seu sistema."
else
    echo "Listando os Deployments no cluster:"
    echo "-----------------------------------"

    # Listando os Deployments
    kubectl get deployments --all-namespaces

    echo "Digite o nome do Deployment para realizar o rollout (ou 'sair' para sair):"
    read deployment_name

    if [ "$deployment_name" != "sair" ]; then
        echo "Realizando o rollout do Deployment $deployment_name..."
        kubectl rollout restart deployment "$deployment_name"
    else
        echo "Saindo do script."
    fi
fi
