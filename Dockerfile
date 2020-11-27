FROM mcr.microsoft.com/dotnet/sdk:5.0.100-focal-arm64v8

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install python3 python3-pip python3-dev ipython3 nano julia

RUN apt-get -y install nmap 
RUN apt-get -y install libffi-dev
RUN apt-get -y install bash
RUN pip3 install jupyterlab

RUN apt-get -y install nodejs \
    && pip3 install --upgrade jupyterlab-git \
    && jupyter lab build

ARG NB_USER="jupyter"
ARG NB_UID="1000"
ARG NB_GID="100"

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER

USER $NB_USER

ENV HOME=/home/$NB_USER

WORKDIR $HOME

ENV PATH="${PATH}:$HOME/.dotnet/tools/"

RUN dotnet tool install -g Microsoft.dotnet-interactive --add-source "https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-tools/nuget/v3/index.json"

RUN dotnet-interactive jupyter install

RUN julia -e 'using Pkg; pkg"add IJulia; add Plots; add CSV; add DataFrames"'

RUN jupyter kernelspec list

RUN mkdir -p $HOME/notebook/.jupyter
COPY ./jupyter_notebook_config.py $HOME/notebook/.jupyter/jupyter_notebook_config.py

RUN mkdir $HOME/notebook/work
COPY example.ipynb $HOME/notebook/work/example.ipynb

USER root

RUN apt-get install sudo \
    && usermod -aG sudo $NB_USER

# prevent git init on this level
RUN mkdir $HOME/notebook/work/.git
COPY start.sh /start.sh
RUN chmod +x /start.sh
USER $NB_USER

CMD ["/start.sh"]
