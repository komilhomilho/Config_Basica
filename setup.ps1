git clone "https://github.com/komilhomilho/Config_Basica"
Set-Location .\Config_Basica

# 1. Carrega o JSON
$caminhosJson = Get-Content -Path "./caminho_arquivos.json" -Raw | ConvertFrom-Json

# 2. Resolve o caminho relativo para absoluto para garantir que o PowerShell o encontre
$caminhoArquivo = Resolve-Path $caminhosJson.opcoes."0"

# 3. Carrega a função na sessão atual (Dot Sourcing)
. $caminhoArquivo

# 4. Agora a função está disponível para ser chamada direto
config_basica