function criptografarDados {
    param()
    
    # Inicia um loop que so vai parar quando o dado for salvo (break) ou a pessoa cancelar (return)
    while ($true) {
        $alias = Read-Host "Qual o dado guardo (ex: github, senha...)"
    
        if (-not $alias) { 
            Write-Host "O alias nao pode ser vazio. Tente novamente." -ForegroundColor Red
            continue # Volta pro inicio do loop
        }

        $caminhoArquivo = "../database/dadosCriptografados.json"
        $pasta = Split-Path $caminhoArquivo

        # Garante que a pasta existe
        if (-not (Test-Path $pasta)) {
            New-Item -ItemType Directory -Path $pasta | Out-Null
        }

        # ============================================================
        # VERIFICACAO DO ALIAS ANTES DE CRIPTOGRAFAR
        # ============================================================
        $aliasDuplicado =$false

        if (Test-Path $caminhoArquivo) {
            # CORRECAO: Adicionado o espaco que faltava no -Path
            $dadosJson = Get-Content -Path $caminhoArquivo -Raw | ConvertFrom-Json
        
            if ($dadosJson.dadosCriptografados -isnot [array]) {
                $dadosJson.dadosCriptografados = @($dadosJson.dadosCriptografados)
            }

            # Checa se o alias ja existe em algum dos objetos salvos
            foreach ($item in $dadosJson.dadosCriptografados) {
                if ($item.psobject.properties.name -contains$alias) {
                    Write-Host "`nErro: Ja existe um dado salvo com o nome '$alias'!" -ForegroundColor Red
                    $aliasDuplicado = $true
                    break # Sai apenas do foreach
                }
            }
        }
        else {
            # Se o arquivo nao existir, cria a estrutura do zero na memoria
            $dadosJson = [PSCustomObject]@{
                dadosCriptografados = @()
            }
        }

        # Se encontrou duplicata, recomeca o loop principal pedindo outro alias
        if ($aliasDuplicado) {
            continue
        }

        # ============================================================
        # CRIPTOGRAFIA (So chega aqui se o alias for valido e novo)
        # ============================================================
        
        $SenhaTexto = Read-Host "Qual a senha de criptografia do texto" -AsSecureString
        $TextoParaCriptografar = Read-Host "O que deseja Criptografar"

        if (-not $TextoParaCriptografar) { return }

        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SenhaTexto)
        $SenhaLimpa = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    
        $Hasher = [System.Security.Cryptography.SHA256]::Create()
        $ChaveBytes = $Hasher.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($SenhaLimpa))
    
        $Aes = [System.Security.Cryptography.Aes]::Create()
        $Aes.Key = $ChaveBytes
        $Aes.GenerateIV() 
    
        $TextoBytes = [System.Text.Encoding]::UTF8.GetBytes($TextoParaCriptografar)
        $Encryptor = $Aes.CreateEncryptor()
        $ResultadoBytes = $Encryptor.TransformFinalBlock($TextoBytes, 0, $TextoBytes.Length)
    
        $PacoteFinal = New-Object Byte[] ($Aes.IV.Length + $ResultadoBytes.Length)
        [Array]::Copy($Aes.IV, 0, $PacoteFinal, 0, $Aes.IV.Length)
        [Array]::Copy($ResultadoBytes, 0, $PacoteFinal, $Aes.IV.Length, $ResultadoBytes.Length)
    
        $CriptografadoBase64 = [Convert]::ToBase64String($PacoteFinal)
    
        $Aes.Dispose()
        $Hasher.Dispose()
    
        # ============================================================
        # SALVANDO NO JSON
        # ============================================================
        $novoDado = @{
            $alias = $CriptografadoBase64
        }
    
        $dadosJson.dadosCriptografados += $novoDado
        $dadosJson | ConvertTo-Json -Depth 10 | Set-Content -Path $caminhoArquivo

        Write-Host "`nO dado '$alias' foi criptografado e salvo com sucesso!" -ForegroundColor Green
        
        # O script deu certo! Sai do loop para nao perguntar de novo.
        break 
    }
}


criptografarDados