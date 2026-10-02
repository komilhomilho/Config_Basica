function AtualizarMenuJson {
    # 1. Define onde estão as funções e onde o JSON será salvo
    # Usamos caminhos relativos (.) para funcionar em qualquer PC (Linux ou Windows)
    $pastaFuncoes = "../funcoes"
    $caminhoJson = "$PSScriptRoot/../database/caminho_arquivos.json"

    # Verifica se a pasta funcoes existe
    if (-not (Test-Path $pastaFuncoes)) {
        Write-Host "A pasta $pastaFuncoes não foi encontrada!" -ForegroundColor Red
        return
    }

    # Garante que a pasta database existe para salvar o JSON
    $pastaDatabase = Split-Path $caminhoJson
    if (-not (Test-Path $pastaDatabase)) {
        New-Item -ItemType Directory -Path $pastaDatabase | Out-Null
    }

    # 2. Busca todos os arquivos .ps1 dentro da pasta funcoes
    $arquivosPs1 = Get-ChildItem -Path $pastaFuncoes -Filter "*.ps1"
    
    $listaCaminhos = @()

    # 3. Monta o caminho relativo (ex: ./funcoes/sair.ps1) para cada arquivo
    foreach ($arquivo in $arquivosPs1) {
        $caminhoRelativo = "./funcoes/$($arquivo.Name)"
        $listaCaminhos += $caminhoRelativo
    }

    # 4. Cria o objeto no formato exato que o seu script principal espera
    $objetoJson = @{
        opcoes = $listaCaminhos
    }

    # 5. Converte para JSON e salva no arquivo
    $objetoJson | ConvertTo-Json -Depth 10 | Set-Content -Path $caminhoJson

    Write-Host "Arquivo JSON atualizado com sucesso!" -ForegroundColor Green
    Write-Host "Foram encontrados $($listaCaminhos.Count) scripts na pasta." -ForegroundColor Cyan
}

AtualizarMenuJson