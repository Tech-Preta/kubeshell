#!/bin/bash

# Verifica se o kubectl está instalado
kubectl_installed=$(command -v kubectl)

if [ -z "$kubectl_installed" ]; then
    echo "O kubectl não está instalado no seu sistema."
else
    echo "Verificando a integridade dos componentes do Kubernetes:"
    echo "-----------------------------------------"

    components=("kubelet" "etcd" "kube-apiserver" "kube-scheduler" "kube-controller-manager" "container-runtime" "kube-proxy")

    for comp in "${components[@]}"; do
        status=$(kubectl get componentstatus "$comp" -o jsonpath='{.conditions[0].status}')
        if [ "$status" == "True" ]; then
            echo "Componente: $comp - Status: Ativo"
        else
            echo "Componente: $comp - Status: Inativo"
        fi
    done
fi
