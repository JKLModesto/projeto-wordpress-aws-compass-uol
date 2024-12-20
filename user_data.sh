#!/bin/bash

# Atualiza o sistema e instala dependências
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y docker.io

# Instalar docker-compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER
newgrp docker

# Configura o diretório para o projeto WordPress
PROJECT_DIR=/home/ubuntu/wordpress
sudo mkdir -p $PROJECT_DIR
sudo chown -R $USER:$USER $PROJECT_DIR
cd $PROJECT_DIR

# Cria o arquivo docker-compose.yml
sudo tee docker-compose.yml > /dev/null <<EOL
version: '3.8'

services:
  wordpress:
    image: wordpress:latest
    container_name: wordpress
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: <host>:3306
      WORDPRESS_DB_USER: admin
      WORDPRESS_DB_PASSWORD: password
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wordpress_data:/var/www/html

volumes:
  wordpress_data:
EOL

# Inicia o Docker Compose
docker-compose up -d

