# FROM jupyter/all-spark-notebook
FROM jupyter/all-spark-notebook
# FROM ubuntu:16.04

USER root

# apt-get and system utilities
RUN apt-get update -y && apt-get install -y \
    curl apt-utils apt-transport-https debconf-utils gcc build-essential gdebi g++ software-properties-common libodbc1\
    && rm -rf /var/lib/apt/lists/*
RUN add-apt-repository ppa:xapienz/curl34
RUN apt install -y libcurl3
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/multiarch-support_2.27-3ubuntu1.4_amd64.deb

RUN apt-get install ./multiarch-support_2.27-3ubuntu1.4_amd64.deb
# adding custom MS repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# install SQL Server drivers
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql unixodbc-dev=2.3.7 unixodbc=2.3.7 odbcinst1debian2=2.3.7 

# install SQL Server tools
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# RUN apt-get install -y build-essential unzip python-dev libaio-dev npm gnupg2 gnupg gnupg1 ca-certificates
RUN jupyter labextension install @jupyterlab/debugger
RUN conda install xeus-python -c conda-forge


USER $NB_UID
RUN pip install mlflow boto3
RUN pip install petl
RUN pip install robotframework
RUN conda update -n base conda
RUN conda install -c anaconda pyodbc unixodbc
RUN pip install ntlm-auth
RUN pip install python-ntlm


CMD [ "jupyter",  "notebook", "--ip='*'", "--NotebookApp.token=''", "--NotebookApp.password=''" ]
