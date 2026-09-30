function lista_repo{
    Clear-Host
    Write-Host "--- Consulta de Repositórios GitHub ---" -ForegroundColor Cyan
    
    # O -AsSecureString esconde a senha enquanto você digita no terminal
    $tokenSeguro = Read-Host "Cole seu Personal Access Token (PAT)" -AsSecureString
    
    # Converte a senha segura de volta para texto para poder enviar para a API
    $token = [System.Net.NetworkCredential]::new("", $tokenSeguro).Password

    # Cabeçalhos obrigatórios para a API do GitHub
    $headers = @{
        Authorization = "token $token"
        Accept = "application/vnd.github.v3+json"
    }

    try {
        # O endpoint /user/repos retorna públicos e privados do usuário autenticado    
        
        Write-Host "`nConectando ao GitHub..." -ForegroundColor Yellow
        $repositorios = curl -L \
	-H "Accept: application/vnd.github+json" \
	-H "Authorization: Bearer "+ $token \
	-H "X-GitHub-Api-Version: 2026-03-10" \
	https://api.github.com/user/repos
        
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
