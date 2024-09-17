#!/usr/bin/env bash

echo Installing Docker

sudo apt install -y ca-certificates curl gnupg

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs)\
	stable"

sudo apt update && sudo apt install --install-recommends -y \
	docker-ce \
	docker-ce-cli \
	containerd.io \
	docker-compose-plugin \
	docker-buildx-plugin \
	docker-ce-rootless-extras

sudo service docker start

sudo sed -i "s/#DOCKER_OPTS/DOCKER_OPTS/g" /etc/default/docker

GROUP=docker
! [ "$(getent group "$GROUP")" ] && sudo groupadd "$GROUP"
if id -nG "$USER" | grep -qw "$GROUP"; then
    echo "$USER" already belongs to "$GROUP"
else
		sudo usermod -aG docker "$USER"
		newgrp docker
fi

docker --version

echo Installing Docker NVIDIA Toolkit

distribution=$(. /etc/os-release;echo "$ID""$VERSION_ID") \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/"$distribution"/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt update && sudo apt install -y nvidia-container-toolkit --install-recommends

sudo systemctl restart docker
