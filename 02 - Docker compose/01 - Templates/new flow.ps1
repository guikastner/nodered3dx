# ==============================
# Configurações de Caminhos
# ==============================

# Caminho absoluto para o secrets.json
$SecretsFile = "E:\3DDrive\3DDrive_DSEXT001\Workshops\2025\works_show\nodered3dx\00 - Settings\secrets.json"

# Caminho relativo ao arquivo base (BasePath será carregado do secrets.json)
$TemplateRelativePath = "02 - Docker compose\01 - Templates\template1_flows.json"
$OutputRelativePath = "02 - Docker compose\01 - Templates\flows.json"

# ==============================
# Inicialização
# ==============================

# Verifique se o arquivo secrets.json existe
if (Test-Path -Path $SecretsFile) {
    $BasePath = (Get-Content -Path $SecretsFile | ConvertFrom-Json).basefolder
}
else {
    Write-Host "ERRO: O arquivo 'secrets.json' não foi encontrado em: $SecretsFile" -ForegroundColor Red
    exit 1
}

# Caminhos completos derivados
$TemplatePath = Join-Path -Path $BasePath -ChildPath $TemplateRelativePath
$OutputPath = Join-Path -Path $BasePath -ChildPath $OutputRelativePath

# ==============================
# Validação de Arquivos
# ==============================

function Validate-FileExists {
    param (
        [string]$FilePath,
        [string]$Description
    )
    if (-Not (Test-Path -Path $FilePath)) {
        Write-Host "ERRO: O arquivo '$Description' não foi encontrado em: $FilePath" -ForegroundColor Red
        exit 1
    }
}

# Valide os arquivos necessários
Validate-FileExists -FilePath $SecretsFile -Description "secrets.json"
Validate-FileExists -FilePath $TemplatePath -Description "template1_flows.json"

# ==============================
# Processamento
# ==============================

# Leia os dados do secrets.json
$Secrets = Get-Content -Path $SecretsFile | ConvertFrom-Json

# Leia o conteúdo do template
$TemplateContent = Get-Content -Path $TemplatePath -Raw

# Substitua os placeholders pelos valores reais do secrets.json
$TemplateContent = $TemplateContent -replace "{{messagebusurl}}", $Secrets.messagebusurl
$TemplateContent = $TemplateContent -replace "{{tenant}}", $Secrets.tenant
$TemplateContent = $TemplateContent -replace "{{compassurl}}", $Secrets.compassurl
$TemplateContent = $TemplateContent -replace "{{topic}}", $Secrets.topic

# Crie o diretório de saída, se não existir
$OutputDir = Split-Path -Path $OutputPath
if (-Not (Test-Path -Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    Write-Host "Aviso: Diretório de saída criado em: $OutputDir" -ForegroundColor Yellow
}

# Salve o conteúdo modificado no novo arquivo flows.json
Set-Content -Path $OutputPath -Value $TemplateContent -Encoding UTF8

# ==============================
# Finalização
# ==============================

# Mensagem de sucesso
Write-Host "Arquivo 'flows.json' gerado com sucesso em: $OutputPath" -ForegroundColor Green