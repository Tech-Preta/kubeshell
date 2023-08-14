#!/bin/bash

# Verifica se o Helm está instalado
helm_installed=$(command -v helm)

if [ -z "$helm_installed" ]; then
    echo "O Helm não está instalado no seu sistema."
else
    echo "Verificando atualizações para aplicações instaladas via Helm:"
    echo "-----------------------------------------"
    
    # Obtém a lista de aplicações instaladas
    installed_apps=$(helm list --all-namespaces -o json | jq -r '.[] | .name + "," + .namespace')

    # Loop pelas aplicações
    for app in $installed_apps; do
        app_name=$(echo "$app" | cut -d ',' -f 1)
        app_namespace=$(echo "$app" | cut -d ',' -f 2)
        
        echo "Aplicação: $app_name (Namespace: $app_namespace)"
        
        # Verifica se há atualizações disponíveis
        update_info=$(helm search repo "$app_name" -l -o json | jq -r '.[0] | select(.appVersion != null) | .appVersion')
        
        if [ -z "$update_info" ]; then
            echo "Nenhuma atualização disponível."
        else
            echo "Atualização disponível: $update_info"
        fi
        
        echo "-----------------------------------------"
    done
fi
