#!/bin/bash

# Autenticando no cluster 
echo "$RD_OPTION_CCO_KUBECONFIG" | base64 -d > /tmp/config
export KUBECONFIG=/tmp/config

# Endereço de e-mail de destino
recipient="natalia.granato@jackexperts.com"

# Sua conta do Gmail
gmail_user="$RD_OPTION_GMAIL_USER"
gmail_password="$RD_OPTION_GMAIL_PASSWORD"

# Função para enviar e-mail usando curl e SMTP
send_email() {
    local subject="Resultado da Verificação de Falhas no Kubernetes"
    local body="$1"
    
    echo -e "To: $recipient\nSubject: $subject\n\n$body" | curl -s --url "smtps://smtp.gmail.com:465" --ssl-reqd --mail-from "$gmail_user" --mail-rcpt "$recipient" --user "$gmail_user:$gmail_password" -T -
}

# Verifica jobs com falha
failed_jobs=$(kubectl get jobs --all-namespaces -o json | jq -r '.items[] | select(.status.conditions[] | select(.type=="Failed")) | .metadata.namespace + "/" + .metadata.name')

# Verifica cronjobs com falha
failed_cronjobs=$(kubectl get cronjobs --all-namespaces -o json | jq -r '.items[] | select(.status.failed > 0) | .metadata.namespace + "/" + .metadata.name')

result=""

if [ -n "$failed_jobs" ]; then
    result+="Jobs com falha:\n$failed_jobs\n\n"
    echo "Deletando pods dos jobs com falha..."
    for job in $failed_jobs; do
        namespace=$(echo $job | cut -d'/' -f1)
        job_name=$(echo $job | cut -d'/' -f2)
        kubectl delete pods -n $namespace -l job-name=$job_name
    done
else
    result+="Nenhum job com falha encontrado.\n\n"
fi

if [ -n "$failed_cronjobs" ]; then
    result+="CronJobs com falha:\n$failed_cronjobs\n\n"
    echo "Deletando pods dos CronJobs com falha..."
    for cronjob in $failed_cronjobs; do
        namespace=$(echo $cronjob | cut -d'/' -f1)
        cronjob_name=$(echo $cronjob | cut -d'/' -f2)
        kubectl delete pods -n $namespace -l cronjob-name=$cronjob_name
    done
else
    result+="Nenhum CronJob com falha encontrado.\n\n"
fi

# Envia e-mail com o resultado
send_email "$result"
