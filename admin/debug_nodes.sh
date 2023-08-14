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
        echo "Escolha o nó para fazer o deploy do kubectl-debug:"
        select node in $nodes; do
            if [ -n "$node" ]; then
                echo "Você escolheu o nó: $node"
                read -p "Informe a imagem para o kubectl-debug (ex: busybox): " image
                read -p "Tem certeza de que deseja fazer o deploy do kubectl-debug com a imagem $image no nó $node? (s/n): " choice
                if [ "$choice" == "s" ]; then
                    kubectl debug node/"$node" --image="$image"
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
