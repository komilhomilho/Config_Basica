
function lista_repo {
    Clear-Host
    Write-Host "--- Consulta de Repositórios GitHub ---" -ForegroundColor Cyan
    
    # O -AsSecureString esconde a senha enquanto você digita no terminal
    $tokenSeguro = Read-Host "Cole seu Personal Access Token (PAT)" -AsSecureString
    
    # Converte a senha segura de volta para texto para poder enviar para a API
    $token = [System.Net.NetworkCredential]::new("", $tokenSeguro).Password

    try {
        Write-Host "`nConectando ao GitHub..." -ForegroundColor Yellow
        
        # 1. Usamos a crase (`) para quebrar linha
        # 2. O token vai direto dentro das aspas
        # 3. Adicionei o -s (silent) para o curl não sujar a tela com a barra de download
        $respostaCurl = curl -s -L `
            -H "Accept: application/vnd.github+json" `
            -H "Authorization: Bearer $token" `
            -H "X-GitHub-Api-Version: 2022-11-28" `
            https://api.github.com/user/repos
        
        # Converte o texto JSON que o curl devolveu para um objeto do PowerShell
        $repositorios =$respostaCurl | ConvertFrom-Json
        
        Write-Host "`n==================================" -ForegroundColor Cyan
        Write-Host "       MEUS REPOSITÓRIOS" -ForegroundColor White
        Write-Host "==================================" -ForegroundColor Cyan
        
        foreach ($repo in $repositorios) {
            if ($repo.private) {
                Write-Host "[PRIVADO] " -ForegroundColor Red -NoNewline
            } else {
                Write-Host "[PUBLICO] " -ForegroundColor Green -NoNewline
            }
            Write-Host $repo.name
        }
        
    } catch {
        Write-Host "`nErro ao conectar: Verifique se o seu Token é válido e se você tem internet." -ForegroundColor Red
    }
}

lista_repo
