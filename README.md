# Kubeshell - Scripts Úteis para Administradores de Clusters Kubernetes

O projeto Kubeshell é uma coleção de scripts úteis e ferramentas de linha de comando para ajudar administradores de clusters Kubernetes a realizar tarefas comuns de administração, solução de problemas e segurança de maneira mais eficiente. Esses scripts são projetados para simplificar várias atividades do dia a dia e fornecer insights valiosos sobre o estado e a segurança do seu cluster.

## Introdução

O Kubernetes é uma plataforma poderosa para orquestração de contêineres, mas a administração e manutenção de clusters podem ser complexas. O projeto Kubeshell visa simplificar essa tarefa, fornecendo uma coleção de scripts que automatizam tarefas comuns e fornecem insights úteis sobre o estado do cluster.

## Scripts Disponíveis

O projeto Kubeshell inclui uma variedade de scripts que abordam várias áreas da administração e segurança de clusters Kubernetes. Alguns dos scripts incluídos são:

- check-pods-health.sh: verifica o estado de saúde dos pods no cluster, identificando pods com problemas.

- check-ingress-services.sh: verifica ingresses que não estão apontando para serviços válidos.

- unused_pvcs.sh: identifica e lista Persistent Volume Claims (PVCs) não utilizados em um cluster Kubernetes e oferece a opção de removê-los.

- jobs_cron_failed.sh: verifica e lista os jobs e cron jobs que falharam em um cluster Kubernetes, removendo os pods lançados com erros.

E muitos outros scripts para diversas tarefas de administração e segurança.

## Requisitos

Certifique-se de ter os seguintes requisitos antes de usar os scripts do Kubeshell:

[kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/): A ferramenta de linha de comando Kubernetes.

[jq](https://jqlang.github.io/jq): Um utilitário de linha de comando para manipulação de JSON.
Outras dependências podem ser mencionadas nos scripts individuais.

## Instruções de Uso

1. Clone este repositório em sua máquina local:

```
git clone https://github.com/nataliagranato/kubeshell.git
```

2. Navegue para o diretório do projeto:

```
cd kubeshell
```

3. Execute os scripts desejados conforme as instruções fornecidas em cada um.

## Contribuição

Contribuições são bem-vindas! Se você deseja adicionar novos scripts, aprimorar os existentes ou sugerir melhorias, sinta-se à vontade para criar um pull request.

## Licença

Este projeto é licenciado sob a [GNU General Public License v3.0](https://github.com/nataliagranato/kubeshell/blob/main/LICENSE).
