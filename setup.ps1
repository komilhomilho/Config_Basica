Set-Location $HOME

if (Test-Path ".\Config_Basica") {
    Remove-Item -Recurse -Force .\Config_Basica
}
if (-not (Test-Path ".\Config_Basica")) {
    git clone "https://github.com/komilhomilho/Config_Basica"
}
Set-Location .\Config_Basica

$caminhos = @()
$caminhosJson = Get-Content -Path "./database/caminho_arquivos.json" -Raw | ConvertFrom-Json

foreach ($caminho in $caminhosJson.opcoes) {
    $caminhoAbsoluto = (Resolve-Path $caminho).Path
    $caminhos += $caminhoAbsoluto
}
$menuAtivo = $true
$contador = 1
while ($menuAtivo) {
    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host "          FERRAMENTAS DO GIT        " -ForegroundColor White
    Write-Host "=============================================================" -ForegroundColor Cyan
    foreach ($nome in $caminhos) {
        Write-Host $contador". "(Get-Item $nome).BaseName
        $contador++
    }
    Write-Host "=============================================================" -ForegroundColor Cyan

    $escolha = Read-Host "Digite o numero desejado"
    $escolha = [int]$escolha

    $escolha -= 1 

    $arquivoEscolhido = $caminhos[$escolha]
    . $arquivoEscolhido
    $arquivoEscolhido = [System.IO.Path]::GetFileNameWithoutExtension($arquivoEscolhido)
    & $arquivoEscolhido
    
    
    Write-Host "" # Pula uma linha para o resultado ficar mais legível
    $contador = 1
}

Write-Host "Caminhos salvos no array:" -ForegroundColor Cyan
$caminhos
