# Use a imagem base do Node-RED
FROM nodered/node-red:4.0.5

# Troque temporariamente para o usuário root para instalar pacotes globalmente
USER root

# Configurações do npm para o @widget-lab registry
RUN npm config set @widget-lab:registry https://itgit.dsone.3ds.com/api/v4/packages/npm/
RUN npm config set "//itgit.dsone.3ds.com/api/v4/packages/npm/:_authToken" "61qKzSxnrLqyeyBy1H-o"

# Instalar uma versão específica do node-fetch compatível com CommonJS
#RUN npm install -g node-fetch@2

# Instalar o pacote específico @widget-lab/node-red-contrib-3dxinterfaces
RUN npm install @widget-lab/node-red-contrib-3dxinterfaces@4.1.1

# Instalar a versão mais atual do axios
RUN npm install node-red-contrib-axios
RUN npm install node-red-node-mysql

# Copie os arquivos flows.json e flows_cred.json para o diretório /data do contêiner
COPY flows.json /data/
COPY flows_cred.json /data/

# Crie as pastas PDF, Solidworks, e CATIAV5 dentro de /data com permissões de escrita
RUN mkdir -p /data/PDF
RUN mkdir -p /data/Solidworks
RUN mkdir -p /data/CATIAV5
RUN chmod -R 777 /data/PDF
RUN chmod -R 777 /data/Solidworks
RUN chmod -R 777 /data/CATIAV5

# Altere as permissões do diretório /data (caso necessário)
RUN chown -R node-red:node-red /data

# Volte para o usuário padrão do Node-RED
USER node-red

# Volte para o diretório padrão do Node-RED
WORKDIR /usr/src/node-red

# Expor a porta que o Node-RED irá rodar
EXPOSE 1880

# Comando para iniciar o Node-RED
CMD ["npm", "start", "--", "--userDir", "/data"]