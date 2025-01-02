# Defina o caminho base para otimizar o script
$BasePath = "E:\3DDrive\3DDrive_DSEXT001\Workshops\2025\works_show\nodered3dx"

# Defina o diretório onde o Dockerfile está localizado
$ImageDir = "$BasePath\Nodered Image"

# Defina o nome e a versão da imagem Docker
$ImageVersion = "1.0.0"
$ImageName = "gkastner/works_show:$ImageVersion"

# Navegar para o diretório da imagem
Set-Location -Path $ImageDir

# Login no Docker Hub (opcional, caso você não esteja autenticado)
Write-Host "Fazendo login no Docker Hub..."
docker login

# Construir a imagem Docker
Write-Host "Construindo a imagem Docker..."
docker build -t $ImageName .

# Push da imagem para o Docker Hub
Write-Host "Enviando a imagem para o Docker Hub..."
docker push $ImageName

# Mensagem de sucesso
Write-Host "Imagem Docker '$ImageName' criada e enviada para o Docker Hub com sucesso!" -ForegroundColor Green