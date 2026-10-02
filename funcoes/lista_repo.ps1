function lista_repo {
    Clear-Host
    Write-Host "--- Consulta de Repositorios GitHub ---" -ForegroundColor Cyan
    
    # O -AsSecureString esconde a senha enquanto voce digita no terminal
    $caminhoArquivo = "$PSScriptRoot/../database/dadosCriptografados.json" 
    $dadosJson = Get-Content -Path $caminhoArquivo -Raw | ConvertFrom-Json

    if (-not $dadosJson.dadosCriptografados) {
        Write-Host "Nenhum dado salvo ainda." -ForegroundColor Yellow
        return
    }
    Write-Host "`n==================================" -ForegroundColor Cyan
    Write-Host "       DADOS CRIPTOGRAFADOS" -ForegroundColor White
    Write-Host "==================================" -ForegroundColor Cyan

    $listaAliases = @()
    foreach ($item in $dadosJson.dadosCriptografados) {
        # O psobject.properties.name pega o nome da chave (ex: "git")
        $nomeAlias = $item.psobject.properties.name
        Write-Host "- $nomeAlias"
        $listaAliases += $nomeAlias
    }
    Write-Host "==================================" -ForegroundColor Cyan

    # 4. Pede para o usuario escolher o que quer carregar
    $aliasEscolhido = Read-Host "`nQual pertence vc ira usar?"
    if ($listaAliases -notcontains $aliasEscolhido) {
        Write-Host "Alias '$aliasEscolhido' nao encontrado." -ForegroundColor Red
        return
    }
    
    $token = [Environment]::GetEnvironmentVariable($aliasEscolhido)

    try {
        Write-Host "`nConectando ao GitHub..." -ForegroundColor Yellow
        
        # Truque Mágico: Se existir o curl.exe (Windows), usa ele. Se não (Linux), usa o curl normal.
        $comandoCurl = if (Get-Command curl.exe -ErrorAction SilentlyContinue) { "curl.exe" } else { "curl" }
        
        # O "&" no início diz pro PowerShell executar o comando que está dentro da variável
        $respostaCurl = &$comandoCurl -s -L `
            -H "Accept: application/vnd.github+json" `
            -H "Authorization: Bearer $token" `
            -H "X-GitHub-Api-Version: 2022-11-28" `
            https://api.github.com/user/repos
        
        # Converte o texto JSON que o curl devolveu para um objeto do PowerShell
        $repositorios = $respostaCurl | ConvertFrom-Json
        
        Write-Host "`n==================================" -ForegroundColor Cyan
        Write-Host "       MEUS REPOSITORIOS" -ForegroundColor White
        Write-Host "==================================" -ForegroundColor Cyan
        
        foreach ($repo in $repositorios) {
            if ($repo.private) {
                Write-Host "[PRIVADO] " -ForegroundColor Red -NoNewline
            }
            else {
                Write-Host "[PUBLICO] " -ForegroundColor Green -NoNewline
            }
            Write-Host $repo.name
        }
        
    }
    catch {
        Write-Host "`nErro ao conectar: Verifique se o seu Token e valido." -ForegroundColor Red
    }
}

lista_repo