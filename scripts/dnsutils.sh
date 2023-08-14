#!/bin/bash

# Verifica se o kubectl está instalado
kubectl_installed=$(command -v kubectl)

if [ -z "$kubectl_installed" ]; then
    echo "O kubectl não está instalado no seu sistema."
else
    echo "Aplicando o dnsutils.yaml:"
    echo "-----------------------------------------"

    # Aplicação do arquivo dnsutils.yaml
    kubectl apply -f https://k8s.io/examples/admin/dns/dnsutils.yaml

    echo "Esperando o pod estar pronto..."
    sleep 10

    # Obter nome do pod
    pod_name=$(kubectl get pods -n default -l k8s-app=dnsutils -o jsonpath='{.items[0].metadata.name}')

    echo "Status do Pod:"
    kubectl get pods -n kube-system "$pod_name"

    echo "Executando nslookup no ambiente do pod..."
    kubectl exec -n kube-system -it "$pod_name" -- nslookup kubernetes.default

    echo "Verificando o arquivo resolv.conf..."
    kubectl exec -n kube-system -it "$pod_name" -- cat /etc/resolv.conf

    echo "Verificando se o DNS está funcionando corretamente..."
    kubectl exec -n kube-system -it "$pod_name" -- nslookup kubernetes.default

    echo "Verificando se o DNS pod está em execução..."
    kubectl get pods -n kube-system -l k8s-app=kube-dns

    echo "Verificando logs do CoreDNS..."
    kubectl logs -n kube-system -l k8s-app=kube-dns

    echo "Verificando o serviço DNS..."
    kubectl get svc -n kube-system kube-dns

    echo "Verificando endpoints do DNS..."
    kubectl get endpoints -n kube-system kube-dns
fi


