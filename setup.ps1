git clone "https://github.com/komilhomilho/Config_Basica"
Set-Location .\Config_Basica
$caminhos = @()

$caminhosJson = Get-Content -Path "./caminho_arquivos.json" -Raw | ConvertFrom-Json

foreach($caminho in $caminhosJson.opcoes){
    $caminhos += Resolve-Path caminho
}