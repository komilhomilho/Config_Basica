function sair{
    param()
    Write-Host "Limpando rastros na memoria..." -ForegroundColor Yellow

    $caminhoArquivo = "./database/dadosCriptografados.json"
    
    if (Test-Path $caminhoArquivo) {
        $dadosJson = Get-Content -Path $caminhoArquivo -Raw | ConvertFrom-Json
        
        if ($dadosJson.dadosCriptografados) {
            foreach ($item in $dadosJson.dadosCriptografados) {
                $nomeAlias = $item.psobject.properties.name
                Remove-Item -Path "Env:\$nomeAlias" -ErrorAction SilentlyContinue
            }
        }
    }

    Write-Host "Memoria limpa com sucesso. Saindo..." -ForegroundColor Green
    Start-Sleep -Seconds 1
    exit
}

sair