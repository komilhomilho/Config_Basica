Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "⚙️  INICIANDO CONFIGURAÇÃO AUTOMÁTICA DA FACULDADE (POWERSHELL)" -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan

# 1. Configura sua identidade global na máquina da faculdade
git config --global user.name "komilhomilho"
git config --global user.email "alexpieetro@gmail.com"
git config --global credential.helper manager
Write-Host "✅ Identidade global configurada!" -ForegroundColor Green

# 2. Cria o atalho 'git salvar' adaptado para rodar perfeitamente no PowerShell/Windows
git config --global alias.salvar "!git add . && git commit -m \"Auto commit: \$(date '+%d/%m/%Y %H:%M:%S')\" && git push"
Write-Host "🚀 Atalho 'git salvar' criado para uso geral." -ForegroundColor Green

Write-Host "---------------------------------------------------------"
Write-Host "📝 Atualizando o histórico do Config_Basica via Script..."
Write-Host "---------------------------------------------------------"

# 3. Define uma pasta temporária segura no perfil do usuário
$tmpFolder = "$HOME\.tmp_config"
if (Test-Path $tmpFolder) { Remove-Item -Recurse -Force $tmpFolder }
New-Item -ItemType Directory -Path $tmpFolder | Out-Null
Set-Location $tmpFolder

# 4. Clona o seu repositório de forma limpa
git clone "https://github.com/komilhomilho/Config_Basica"
Set-Location .\Config_Basica

# 5. Registra a data e hora atual do sistema no histórico
$dataAtual = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
"Acesso registrado em: $dataAtual" | Out-File -FilePath .\historico_acesso.txt -Append

# 6. Faz o commit local
git add historico_acesso.txt
git commit -m "Auto commit: $dataAtual"

Write-Host ""
Write-Host "🔐 ATENÇÃO: A janela de login do GitHub vai abrir no seu navegador." -ForegroundColor Yellow
Write-Host "👉 Faça o login para autorizar o envio do commit do setup!" -ForegroundColor Yellow
Write-Host ""

# 7. Faz o push para o GitHub (abrindo a tela de login via Web do Windows)
git push origin main

# 8. Limpa os arquivos temporários da máquina ao terminar
Set-Location $HOME
Remove-Item -Recurse -Force $tmpFolder

Write-Host "=========================================================" -ForegroundColor Green
Write-Host "🎉 CONFIGURAÇÃO CONCLUÍDA E HORÁRIO REGISTRADO NO GITHUB!" -ForegroundColor Green
Write-Host "=========================================================" -ForegroundColor Green
