#!/bin/bash

clear
echo "========================================================="
echo "⚙️  INICIANDO CONFIGURAÇÃO AUTOMÁTICA DA FACULDADE"
echo "========================================================="

# 1. Configura sua identidade global na máquina
git config --global user.name "komilhomilho"
git config --global user.email "alexpieetro@gmail.com"
git config --global credential.helper manager
echo "✅ Identidade global configurada!"

# 2. Cria o atalho 'git salvar' para seus outros projetos
git config --global alias.salvar "!git add . && git commit -m \"Auto commit: \$(date '+%d/%m/%Y %H:%M:%S')\" && git push"
echo "🚀 Atalho 'git salvar' criado para uso geral."

echo "---------------------------------------------------------"
echo "📝 Atualizando o histórico do Config_Basica via Script..."
echo "---------------------------------------------------------"

# 3. Entra na pasta temporária do sistema para não bagunçar seu computador
cd /tmp

# 4. Clona o seu repositório de configuração de forma silenciosa
git clone -q https://github.com/komilhomilho/Config_Basica
cd Config_Basica

# 5. Registra a data e hora atual em um arquivo chamado historico_acesso.txt
DATA_ATUAL=$(date '+%d/%m/%Y %H:%M:%S')
echo "Acesso registrado em: $DATA_ATUAL" >> historico_acesso.txt

# 6. Adiciona, faz o commit e envia de volta para o GitHub
git add historico_acesso.txt
git commit -m "Auto commit: $DATA_ATUAL"

echo ""
echo "🔐 ATENÇÃO: A janela de login do GitHub vai abrir no seu navegador."
echo "👉 Faça o login para autorizar o envio do commit do setup!"
echo ""

git push origin main

# 7. Limpa a pasta temporária após o término
cd ..
rm -rf Config_Basica

echo "========================================================="
echo "🎉 CONFIGURAÇÃO CONCLUÍDA E HORÁRIO REGISTRADO NO GITHUB!"
echo "========================================================="

