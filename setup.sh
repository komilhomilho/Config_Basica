#!/bin/bash

echo "========================================================="
echo "⚙️  INICIANDO CONFIGURAÇÃO AUTOMÁTICA DA FACULDADE"
echo "========================================================="

# 1. Configura sua identidade local na máquina
git config --global user.name "komilhomilho"
git config --global user.email "alexpieetro@gmail.com"

# 2. Ativa o login via navegador do GitHub CLI
echo "🔐 Iniciando autenticação Web no GitHub..."
gh auth login --hostname github.com --git-protocol https --web

# 3. Cria um alias 'salvar' que adiciona, commita com data/hora e envia
git config --global alias.salvar "!git add . && git commit -m \"Auto commit: \$(date '+%d/%m/%Y %H:%M:%S')\" && git push"

echo "---------------------------------------------------------"
echo "✅ Pronto! Para salvar seu trabalho agora, basta digitar:"
echo "👉 git salvar"
echo "========================================================="
