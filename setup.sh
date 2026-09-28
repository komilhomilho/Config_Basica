@echo off
cls
echo =========================================================
echo   INICIANDO CONFIGURACAO AUTOMATICA DA FACULDADE (CMD)
echo =========================================================

:: 1. Configura sua identidade global na maquina
git config --global user.name "komilhomilho"
git config --global user.email "alexpieetro@gmail.com"
git config --global credential.helper manager
echo [OK] Identidade global configurada!

:: 2. Cria o atalho 'git salvar' adaptado para rodar no CMD do Windows
git config --global alias.salvar "!git add . && git commit -m \"Auto commit: %%date%% %%time%%\" && git push"
echo [OK] Atalho 'git salvar' criado para uso geral.

echo ---------------------------------------------------------
echo   Atualizando o historico do Config_Basica via CMD...
echo ---------------------------------------------------------

:: 3. Entra na pasta do usuario do Windows e cria uma pasta temporaria
cd %USERPROFILE%
if exist .tmp_config rmdir /s /q .tmp_config
mkdir .tmp_config
cd .tmp_config

:: 4. Clona o seu repositorio
git clone "https://github.com/komilhomilho/Config_Basica/"
cd Config_Basica

:: 5. Pega a data e hora atual do Windows e salva no arquivo
echo Acesso registrado em: %date% %time% >> historico_acesso.txt

:: 6. Faz o commit local
git add historico_acesso.txt
git commit -m "Auto commit: %date% %time%"

echo.
echo  ATENCAO: A janela de login do GitHub vai abrir no seu navegador.
echo  Faca o login para autorizar o envio do commit do setup!
echo.

:: 7. Faz o upload para o GitHub (abrindo a tela de login)
git push origin main

:: 8. Limpa os arquivos temporarios criados na maquina da faculdade
cd %USERPROFILE%
rmdir /s /q .tmp_config

echo =========================================================
echo   CONFIGURACAO CONCLUIDA E HORARIO REGISTRADO NO GITHUB!
echo =========================================================
