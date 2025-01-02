# Defina o caminho base para otimizar o script
$BasePath = "E:\3DDrive\3DDrive_DSEXT001\Workshops\2025\works_show\nodered3dx"

# Defina o diretório onde o arquivo TAR está localizado
$ImageDir = "$BasePath\Nodered Image"

# Defina o nome e a versão da imagem Docker
$ImageVersion = "1.0.0"
$ImageName = "gkastner/works_show:$ImageVersion"

# Defina o caminho para o arquivo TAR
$TarFilePath = "$ImageDir\works_show_image_$ImageVersion.tar"

# Nome do container e do volume (usando a mesma variável)
$ContainerVolumeName = "works_show_nodered"

# Defina a porta do host e do container
$HostPort = 1890
$ContainerPort = 1880

# Carregar a imagem Docker a partir do arquivo TAR
docker load -i $TarFilePath

# Criar e executar o container
docker run -d `
    --name $ContainerVolumeName `
    -p "$HostPort`:$ContainerPort" `
    -v "$ContainerVolumeName`:/data" `
    $ImageName

# Mensagem de conclusão
Write-Host "Container '$ContainerVolumeName' executado com a imagem '$ImageName'."
Write-Host "A porta $HostPort está mapeada para a porta $ContainerPort no Node-RED."
Write-Host "O volume '$ContainerVolumeName' está conectado ao diretório '/data'."
