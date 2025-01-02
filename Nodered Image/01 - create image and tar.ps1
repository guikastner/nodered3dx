# Defina o caminho base para otimizar o script
$BasePath = "E:\3DDrive\3DDrive_DSEXT001\Workshops\2025\works_show\nodered3dx"

# Defina o diretório onde o Dockerfile está localizado
$ImageDir = "$BasePath\Nodered Image"

# Defina o nome e a versão da imagem Docker
$ImageVersion = "1.0.0"
$ImageName = "gkastner/works_show:$ImageVersion"

# Defina o caminho e o nome do arquivo tar, incluindo a versão
$TarFilePath = "$ImageDir\works_show_image_$ImageVersion.tar"

# Navegar para o diretório da imagem
Set-Location -Path $ImageDir

# Construir a imagem Docker
docker build -t $ImageName .

# Salvar a imagem Docker em um arquivo tar no diretório do Dockerfile
docker save -o $TarFilePath $ImageName

# Mensagem de conclusão
Write-Host "Imagem Docker '$ImageName' criada e salva como '$TarFilePath' com sucesso!"
