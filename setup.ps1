Set-Location $HOME

if (-not (Test-Path ".\Config_Basica")) {
    git clone "https://github.com/komilhomilho/Config_Basica"
}
Set-Location .\Config_Basica

$caminhos = @()
$caminhosJson = Get-Content -Path "./caminho_arquivos.json" -Raw | ConvertFrom-Json

foreach ($caminho in $caminhosJson.opcoes) {
    $caminhoAbsoluto = (Resolve-Path $caminho).Path
    $caminhos += $caminhoAbsoluto
}

Write-Host "Caminhos salvos no array:" -ForegroundColor Cyan
$caminhos