# 1. Carrega o JSON
$dados = Get-Content -Path "./caminho_arquivos.json" -Raw | ConvertFrom-Json

# 2. Resolve o caminho relativo para absoluto para garantir que o PowerShell o encontre
$caminhoArquivo = Resolve-Path $dados.opcoes."0"

# 3. Carrega a função na sessão atual (Dot Sourcing)
. $caminhoArquivo

# 4. Agora a função está disponível para ser chamada direto
config_basica