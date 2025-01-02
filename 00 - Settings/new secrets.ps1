# Defina os caminhos relativos
$secretsPath = "secret.json"
$templatePath = "template_flows_cred.json"
$outputDir = "..\Nodered Image"
$outputCredPath = "$outputDir\flows_cred.json"

# Função para verificar se o arquivo existe
function Validate-FileExists($filePath, $description) {
    if (-Not (Test-Path -Path $filePath)) {
        Write-Host "ERRO: O arquivo '$description' não foi encontrado em: $filePath" -ForegroundColor Red
        exit 1
    }
}

# Função para verificar ou criar o diretório de saída
function Validate-OrCreateDirectory($dirPath) {
    if (-Not (Test-Path -Path $dirPath)) {
        Write-Host "Aviso: O diretório de saída não existe. Criando: $dirPath" -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $dirPath -Force
    }
}

# Validar arquivos de entrada
Validate-FileExists $secretsPath "secrets.json"
Validate-FileExists $templatePath "template_flows_cred.json"

# Validar ou criar o diretório de saída
Validate-OrCreateDirectory $outputDir

# Leia os dados do secrets.json
$secrets = Get-Content -Path $secretsPath | ConvertFrom-Json

# Leia o conteúdo do template
$templateContent = Get-Content -Path $templatePath -Raw

# Substitua os placeholders pelos valores reais do secrets.json
$templateContent = $templateContent -replace "{{user}}", $secrets.user
$templateContent = $templateContent -replace "{{password}}", $secrets.password
$templateContent = $templateContent -replace "{{agent}}", $secrets.agent
$templateContent = $templateContent -replace "{{agentPassword}}", $secrets.agentPassword

# Salve o conteúdo modificado no arquivo flows_cred.json
Set-Content -Path $outputCredPath -Value $templateContent -Encoding UTF8

# Mensagem de sucesso
Write-Host "Arquivo 'flows_cred.json' gerado com sucesso em: $outputCredPath" -ForegroundColor Green
