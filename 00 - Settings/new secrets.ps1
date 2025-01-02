# Definir variáveis para nomes de arquivos e diretórios
$secretsFileName = "secrets.json"
$templateFileName = "template_flows_cred.json"
$outputCredFileName = "flows_cred.json"
$settingsDir = "00 - Settings"
$outputDirName = "Nodered Image"

# Obtenha o caminho absoluto do diretório atual do script
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# Caminhos baseados nas variáveis
$secretsPath = Join-Path -Path $scriptDir -ChildPath "$settingsDir\$secretsFileName"
$templatePath = Join-Path -Path $scriptDir -ChildPath "$settingsDir\$templateFileName"
$outputDir = Join-Path -Path $scriptDir -ChildPath $outputDirName
$outputCredPath = Join-Path -Path $outputDir -ChildPath $outputCredFileName

# Função para verificar se o arquivo existe
function Test-FileExists {
    param (
        [string]$FilePath,
        [string]$Description
    )
    if (-Not (Test-Path -Path $FilePath)) {
        Write-Host "ERRO: O arquivo '$Description' não foi encontrado em: $FilePath" -ForegroundColor Red
        exit 1
    }
}

# Função para verificar ou criar o diretório de saída
function Ensure-DirectoryExists {
    param (
        [string]$DirPath
    )
    if (-Not (Test-Path -Path $DirPath)) {
        Write-Host "Aviso: O diretório de saída não existe. Criando: $DirPath" -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $DirPath -Force
    }
}

# Validar arquivos de entrada
Test-FileExists -FilePath $secretsPath -Description "secrets.json"
Test-FileExists -FilePath $templatePath -Description "template_flows_cred.json"

# Validar ou criar o diretório de saída
Ensure-DirectoryExists -DirPath $outputDir

# Leia os dados do secrets.json
$secrets = Get-Content -Path $secretsPath | ConvertFrom-Json

# Leia o conteúdo do template
$templateContent = Get-Content -Path $templatePath -Raw

# Substitua os placeholders pelos valores reais do secrets.json
$templateContent = $templateContent -replace "{{user}}", $secrets.user
$templateContent = $templateContent -replace "{{password}}", $secrets.password
$templateContent = $templateContent -replace "{{agent}}", $secrets.agent

# Corrigir o escaping do agentPassword para que as barras sejam tratadas corretamente
$escapedAgentPassword = $secrets.agentPassword -replace "(\\)", "\\"
$templateContent = $templateContent -replace "{{agentPassword}}", $escapedAgentPassword

# Salve o conteúdo modificado no arquivo flows_cred.json
Set-Content -Path $outputCredPath -Value $templateContent -Encoding UTF8

# Mensagem de sucesso
Write-Host "Arquivo '$outputCredFileName' gerado com sucesso em: $outputDir" -ForegroundColor Green
