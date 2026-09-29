function config_basica {
    param (
    )
    Write-Host "=========================================================" -ForegroundColor Cyan
    Write-Host "  INICIANDO CONFIGURAÇÃO AUTOMÁTICA" -ForegroundColor Cyan
    Write-Host "=========================================================" -ForegroundColor Cyan

    # 1. Configura sua identidade global
    git config --global user.name "komilhomilho"
    git config --global user.email "alexpieetro@gmail.com"
    git config --global credential.helper manager
    Write-Host " Identidade global configurada!" -ForegroundColor Green

    # 2. Cria o atalho 'git salvar'
    git config --global alias.salvar '!git add . && git commit -m "Auto commit: $(date +''%d/%m/%Y %H:%M:%S'')" && git push'
    Write-Host " Atalho 'git salvar' criado para uso geral." -ForegroundColor Green

    Write-Host "---------------------------------------------------------"
    Write-Host " Atualizando o histórico do Config_Basica via Script..."
    Write-Host "---------------------------------------------------------"

    # 3. Define uma pasta temporária segura
    $tmpFolder = "$HOME\.tmp_config"
    if (Test-Path $tmpFolder) { cmd /c rmdir /s /q$tmpFolder }
    New-Item -ItemType Directory -Path $tmpFolder | Out-Null
    Set-Location $tmpFolder

    # 4. Clona o seu repositório
    git clone "https://github.com/komilhomilho/Config_Basica"
    Set-Location .\Config_Basica

    # 5. Registra a data e hora atual
    $dataAtual = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    "Acesso registrado em: $dataAtual" | Out-File -FilePath .\historico_acesso.txt -Append -Encoding utf8

    # 6. Faz o commit
    git add historico_acesso.txt
    git commit -m "Auto commit: $dataAtual"

    Write-Host "` ATENÇÃO: A janela de login do GitHub vai abrir no seu navegador." -ForegroundColor Yellow
    Write-Host " Faça o login para autorizar o envio do commit do setup!`n" -ForegroundColor Yellow

    # 7. Faz o push
    git push origin main

    # 8. Limpa os rastros
    Set-Location $HOME
    cmd /c rmdir /s /q $tmpFolder

    Write-Host "=========================================================" -ForegroundColor Green
    Write-Host " CONFIGURAÇÃO CONCLUÍDA E HORÁRIO REGISTRADO NO GITHUB!" -ForegroundColor Green
    Write-Host "=========================================================" -ForegroundColor Green
}