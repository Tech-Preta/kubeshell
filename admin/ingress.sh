#!/bin/bash

# Verifica se o kubectl está instalado
kubectl_installed=$(command -v kubectl)

if [ -z "$kubectl_installed" ]; then
    echo "O kubectl não está instalado no seu sistema."
else
    echo "Verificando se o objeto IngressClass está instalado no cluster:"
    echo "-----------------------------------------"

    # Verifica se o IngressClass já existe
    ingress_class=$(kubectl get ingressclass -o jsonpath='{.items[*].metadata.name}' 2>/dev/null)

    if [ -z "$ingress_class" ]; then
        echo "O objeto IngressClass não está instalado no cluster."
        echo "Escolha uma opção para fazer o deploy de um controlador de Ingress:"
        echo "1. NGINX Ingress Controller"
        echo "2. Kong Gateway"
        echo "3. Traefik Proxy"
        
        read -p "Digite o número da opção desejada: " choice
        
        case $choice in
            1)
                kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
                echo "O NGINX Ingress Controller foi instalado."
                ;;
            2)
                kubectl apply -f https://bit.ly/k4k8s
                echo "O Kong Gateway foi instalado."
                ;;
            3)
                kubectl apply -f https://raw.githubusercontent.com/containous/traefik/v2.5/examples/k8s/traefik-deployment.yaml
                echo "O Traefik Proxy foi instalado."
                ;;
            *)
                echo "Opção inválida."
                ;;
        esac
    else
        echo "O objeto IngressClass já está instalado no cluster."
    fi
fi
