FROM nvidia/cuda:12.1.1-base-ubuntu22.04

ARG USER = 'docker'
ARG DEVICE_UUID = ''
ARG DEVICE_ID = 0
ARG PORT = 7861

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /workspace

RUN echo "GPU UUID: $DEVICE_UUID"
RUN echo "GPU ID: $DEVICE_ID"
RUN echo "PORT: $PORT"

RUN apt update -y && apt upgrade -y  \
      && apt install -y wget git python3.10 python3-pip python3-venv curl nvidia-driver-530 \
      && apt install -y --no-install-recommends google-perftools

RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID)  \
    && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg  \
    && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list |  \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |  \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
RUN apt update && apt install -y nvidia-container-toolkit
RUN apt -y autoremove && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN adduser --system --group docker

RUN chown -R docker:docker /workspace

USER docker

RUN pip3 install --upgrade pip
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git .
#RUN cd stable-diffusion-webui && python3 launch.py --skip-torch-cuda-test
RUN wget https://huggingface.co/igor-golovach/illuminatiDiffusionV1_v11/resolve/main/illuminatiDiffusionV1_v11.safetensors -P models/Stable-diffusion
#    chmod +x webui.sh && ./webui.sh
#ADD --chown=docker https://huggingface.co/igor-golovach/illuminatiDiffusionV1_v11/resolve/main/illuminatiDiffusionV1_v11.safetensors /workspace/stable-diffusion-webui/models/Stable-diffusion/illuminatiDiffusionV1_v11.safetensors

ADD ./webui-user.sh /workspace/webui-user.sh

EXPOSE $PORT

ENTRYPOINT ["/workspace/webui.sh"]

#CMD ["/bin/bash"]
#CMD python3 webui.py --api --nowebui --xformers --listen --port $PORT --medvram --opt-split-attention --disable-nan-check
