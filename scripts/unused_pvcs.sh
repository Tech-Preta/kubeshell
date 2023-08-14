#!/bin/bash

# Verifica se o kubectl está instalado
kubectl_installed=$(command -v kubectl)

if [ -z "$kubectl_installed" ]; then
    echo "O kubectl não está instalado no seu sistema."
else
    echo "Verificando PersistentVolumeClaims não utilizados no cluster:"
    echo "-----------------------------------------"

    # Obtém a lista de PersistentVolumeClaims no cluster
    pvcs=$(kubectl get pvc --all-namespaces -o jsonpath='{.items[*].metadata.name}' 2>/dev/null)

    if [ -z "$pvcs" ]; then
        echo "Nenhum PersistentVolumeClaim encontrado no cluster."
    else
        unused_pvcs=""
        
        for pvc in $pvcs; do
            used_pvcs=$(kubectl get pod --all-namespaces -o jsonpath='{.items[*].spec.volumes[*].persistentVolumeClaim.claimName}' | grep "$pvc")
            if [ -z "$used_pvcs" ]; then
                unused_pvcs="$unused_pvcs $pvc"
            fi
        done
        
        if [ -z "$unused_pvcs" ]; then
            echo "Não foram encontrados PersistentVolumeClaims não utilizados."
        else
            echo "PersistentVolumeClaims não utilizados:"
            echo "$unused_pvcs"
            
            read -p "Deseja deletar os PersistentVolumeClaims não utilizados? (s/n): " choice
            
            if [ "$choice" == "s" ]; then
                for pvc in $unused_pvcs; do
                    kubectl delete pvc "$pvc"
                    echo "Deleted: $pvc"
                done
            else
                echo "Nenhum objeto foi deletado."
            fi
        fi
    fi
fi
