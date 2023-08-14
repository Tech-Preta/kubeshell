#!/bin/bash

# Verifica se o kubectl está instalado
kubectl_installed=$(command -v kubectl)

if [ -z "$kubectl_installed" ]; then
    echo "O kubectl não está instalado no seu sistema."
else
    echo "Listando nós disponíveis no cluster:"
    echo "-----------------------------------------"

    # Obtém a lista de nós
    nodes=$(kubectl get nodes -o jsonpath='{.items[*].metadata.name}')

    select_node() {
        echo "Escolha o nó que deseja drenar:"
        select node in $nodes; do
            if [ -n "$node" ]; then
                echo "Você escolheu drenar o nó: $node"
                read -p "Tem certeza de que deseja drenar o nó $node? (s/n): " choice
                if [ "$choice" == "s" ]; then
                    kubectl drain "$node" --ignore-daemonsets --delete-local-data
                    echo "Nó $node foi drenado."
                else
                    echo "Operação cancelada."
                fi
                break
            fi
        done
    }

    if [ -z "$nodes" ]; then
        echo "Nenhum nó encontrado no cluster."
    else
        select_node
    fi
fi
