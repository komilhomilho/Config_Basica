function CarregarDadoNaRAM {
    # Ajuste o caminho se precisar rodar de outro diretorio
    $caminhoArquivo = "$PSScriptRoot/../database/dadosCriptografados.json"

    # 1. Verifica se o arquivo existe
    if (-not (Test-Path $caminhoArquivo)) {
        Write-Host "Arquivo de senhas nao encontrado!" -ForegroundColor Red
        return
    }

    # 2. Le o arquivo JSON
    $dadosJson = Get-Content -Path $caminhoArquivo -Raw | ConvertFrom-Json

    if (-not $dadosJson.dadosCriptografados) {
        Write-Host "Nenhum dado salvo ainda." -ForegroundColor Yellow
        return
    }

    # 3. Lista os aliases disponiveis na tela
    Write-Host "`n==================================" -ForegroundColor Cyan
    Write-Host "       DADOS CRIPTOGRAFADOS" -ForegroundColor White
    Write-Host "==================================" -ForegroundColor Cyan

    $listaAliases = @()
    foreach ($item in $dadosJson.dadosCriptografados) {
        # O psobject.properties.name pega o nome da chave (ex: "git")
        $nomeAlias =$item.psobject.properties.name
        Write-Host "- $nomeAlias"
        $listaAliases +=$nomeAlias
    }
    Write-Host "==================================" -ForegroundColor Cyan

    # 4. Pede para o usuario escolher o que quer carregar
    $aliasEscolhido = Read-Host "`nQual alias voce quer carregar na RAM?"

    if ($listaAliases -notcontains $aliasEscolhido) {
        Write-Host "Alias '$aliasEscolhido' nao encontrado." -ForegroundColor Red
        return
    }

    # Pega a string Base64 gigante correspondente ao alias escolhido
    $dadoCriptografadoBase64 = $null
    foreach ($item in $dadosJson.dadosCriptografados) {
        if ($item.psobject.properties.name -eq $aliasEscolhido) {
            $dadoCriptografadoBase64 = $item.$aliasEscolhido
            break
        }
    }

    # 5. Pede a senha mestre
    $SenhaTexto = Read-Host "Digite a senha mestre para descriptografar" -AsSecureString

    # Converte a SecureString em texto limpo
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SenhaTexto)
    $SenhaLimpa = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

    try {
        # Recria a chave usando o mesmo SHA256 da criptografia
        $Hasher = [System.Security.Cryptography.SHA256]::Create()
        $ChaveBytes = $Hasher.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($SenhaLimpa))

        # Transforma o Base64 de volta num array de bytes
        $PacoteFinal = [Convert]::FromBase64String($dadoCriptografadoBase64)

        # O segredo: Separar os primeiros 16 bytes (que sao o IV) do resto (que e a mensagem)
        $IV = New-Object Byte[] 16
        $ResultadoBytes = New-Object Byte[] ($PacoteFinal.Length - 16)

        [Array]::Copy($PacoteFinal, 0, $IV, 0, 16)
        [Array]::Copy($PacoteFinal, 16, $ResultadoBytes, 0, $ResultadoBytes.Length)

        # Configura o motor AES para descriptografar
        $Aes = [System.Security.Cryptography.Aes]::Create()
        $Aes.Key = $ChaveBytes
        $Aes.IV = $IV

        $Decryptor = $Aes.CreateDecryptor()
        $TextoBytes = $Decryptor.TransformFinalBlock($ResultadoBytes, 0, $ResultadoBytes.Length)
        
        # Converte os bytes revelados para o texto final
        $TextoLimpo = [System.Text.Encoding]::UTF8.GetString($TextoBytes)

        # Limpa as chaves sensiveis da memoria do script
        $Aes.Dispose()
        $Hasher.Dispose()
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)

        # ============================================================
        # 6. SALVA O DADO NA VARIAVEL DE AMBIENTE (RAM)
        # ============================================================
        # O Set-Item cria a variavel dinamicamente com o nome do alias!
        Set-Item -Path "Env:$aliasEscolhido" -Value $TextoLimpo

        Write-Host "`nSucesso! O dado foi descriptografado e salvo na RAM." -ForegroundColor Green
        Write-Host "Voce ja pode acessa-lo usando: " -NoNewline
        Write-Host "`$env:$aliasEscolhido" -ForegroundColor Yellow

    } catch {
        Write-Host "`nErro ao descriptografar. A senha esta incorreta!" -ForegroundColor Red
        # Garante que a senha seja apagada da memoria mesmo se der erro
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
    }
}

CarregarDadoNaRAM