#!/usr/bin/env bash

echo Testing Docker/NVIDIA build

docker run --rm --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi
