#!/usr/bin/env bash

echo Adding PPA Repo

sudo add-apt-repository -y -r ppa:graphics-drivers/ppa
sudo add-apt-repository -y ppa:graphics-drivers/ppa

echo Updating APT

sudo apt update && sudo apt install -y ubuntu-drivers-common

echo Install NVIDIA Drivers

sudo ubuntu-drivers --gpgpu autoinstall nvidia

echo Prerequisitie Packages

sudo apt install -y g++ freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev

echo Install CUDA Drivers

sudo apt install -y gcc-10 gcc-11 gcc-12 g++-10 g++-11 g++-12

# echo Uninstall Previous

# ! [ -d /usr/local/cuda-11.2 ] && sudo /usr/local/cuda-11.2/bin/cuda-uninstaller
# ! [ -d /usr/local/cuda-11.8 ] && sudo /usr/local/cuda-11.8/bin/cuda-uninstaller

# CUDA 11.2
if ! [ -d /usr/local/cuda-11.2 ]; then
	alias gcc="gcc-10"
	alias g++="g++-10"
	wget https://developer.download.nvidia.com/compute/cuda/11.2.0/local_installers/cuda_11.2.0_460.27.04_linux.run
	sudo sh cuda_11.2.0_460.27.04_linux.run --silent --override --toolkit --no-drm
	# https://stackoverflow.com/a/46380601
	sudo ln -sf /usr/bin/gcc-11 /usr/local/cuda-11.2/bin/gcc
	sudo ln -sf /usr/bin/g++-11 /usr/local/cuda-11.2/bin/g++
fi

# CUDA 11.8
if ! [ -d /usr/local/cuda-11.8 ]; then
	alias gcc="gcc-11"
	alias g++="g++-11"
	wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run
	sudo sh cuda_11.8.0_520.61.05_linux.run --silent --override --toolkit --no-drm
	# https://stackoverflow.com/a/46380601
	sudo ln -sf /usr/bin/gcc-11 /usr/local/cuda-11.8/bin/gcc
	sudo ln -sf /usr/bin/g++-11 /usr/local/cuda-11.8/bin/g++
fi

# CUDA 12.2
if ! [ -d /usr/local/cuda-12.2 ]; then
	alias gcc="gcc-12"
	alias g++="g++-12"
	wget https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/cuda_12.2.2_535.104.05_linux.run
	sudo sh cuda_12.2.2_535.104.05_linux.run --silent --override --toolkit --samples
	# https://stackoverflow.com/a/46380601
	sudo ln -sf /usr/bin/gcc-12 /usr/local/cuda-12.2/bin/gcc
	sudo ln -sf /usr/bin/g++-12 /usr/local/cuda-12.2/bin/g++
	# cuDNN v 9.0.0
	wget https://developer.download.nvidia.com/compute/cudnn/9.0.0/local_installers/cudnn-local-repo-ubuntu2004-9.0.0_1.0-1_amd64.deb
	sudo dpkg -i cudnn-local-repo-ubuntu2004-9.0.0_1.0-1_amd64.deb
	sudo cp /var/cudnn-local-repo-ubuntu2004-9.0.0/cudnn-*-keyring.gpg /usr/share/keyrings/
	sudo apt update && sudo apt install -y cudnn-cuda-12
fi

[ "$(type gcc)" == "alias" ] && unalias gcc
[ "$(type g++)" == "alias" ] && unalias g++

rm -f *.run

echo Setting default CUDA

sudo ln -sf /usr/local/cuda-12.2 /usr/local/cuda

# DISTRO=$(. /etc/os-release;echo "$ID""$VERSION_ID" | sed -e 's/\.//g')
# ARCH=x86_64
# MAX_CUDA=$(/usr/local/cuda/bin/nvcc --version | grep -o "release[^,]\+" | grep -o "[0-9\.]\+")
