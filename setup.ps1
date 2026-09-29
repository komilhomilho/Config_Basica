Set-Location $HOME
if (Test-Path ".\Config_Basica"){
    Remove-Item -Recurse -Force .\Config_Basica
}
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
$menuAtivo = $true
while($menuAtivo){
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "          FERRAMENTAS DO GIT        " -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host "========================================" -ForegroundColor Cyan
    foreach($nome in $caminhos){
        Write-Host (Get-Item $nome).BaseName
    }
    Write-Host "========================================" -ForegroundColor Cyan

}

Write-Host "Caminhos salvos no array:" -ForegroundColor Cyan
$caminhos