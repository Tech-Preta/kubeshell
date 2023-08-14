#!/bin/bash

# Variável para controlar se erros foram encontrados
errors_found=false

# Array de erros a serem verificados
declare -a errors=("ImagePullBackOff" "ImageInspectError" "ErrImagePull" "ErrImageNeverPull" "RegistryUnavailable" "InvalidImageName" "CrashLoopBackOff" "RunContainerError" "KillContainerError" "VerifyNonRootError" "RunInitContainerError" "CreatePodSandboxError" "ConfigPodSandboxError" "KillPodSandboxError" "SetupNetworkError" "TeardownNetworkError")

# Função para verificar e imprimir informações sobre um pod com erro
check_pod_errors() {
    local pod_name="$1"
    local namespace="$2"
    
    echo "Pod: $pod_name (Namespace: $namespace)"
    kubectl describe pod "$pod_name" -n "$namespace"
    echo "-----------------------------------------"
    
    # Marca que erros foram encontrados
    errors_found=true
}

# Obtém a lista de namespaces
namespaces=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')

# Loop pelos namespaces
for ns in $namespaces; do
    echo "Namespace: $ns"
    echo "-----------------------------------------"

    # Obtém a lista de pods no namespace
    pods=$(kubectl get pods -n "$ns" -o jsonpath='{.items[*].metadata.name}')

    # Loop pelos pods
    for pod in $pods; do
        pod_status=$(kubectl get pod "$pod" -n "$ns" -o jsonpath='{.status.phase}')
        for error in "${errors[@]}"; do
            if [[ "$pod_status" == *"$error"* ]]; then
                check_pod_errors "$pod" "$ns"
                break
            fi
        done
    done

    echo
done

# Se nenhum erro foi encontrado, exibir mensagem
if ! $errors_found; then
    echo "Não foram encontrados pods com estados não saudáveis em nenhum namespace."
fi
