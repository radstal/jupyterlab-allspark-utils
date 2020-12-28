FROM jupyter/all-spark-notebook
USER root
RUN apt-get update -y
RUN apt-get install -y build-essential unzip python-dev libaio-dev npm
RUN jupyter labextension install @jupyterlab/debugger
RUN conda install xeus-python -c conda-forge

RUN wget --no-check-certificate https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-basic-linux.x64-21.1.0.0.0.zip
RUN wget --no-check-certificate https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sdk-linux.x64-21.1.0.0.0.zip


USER $NB_UID
RUN pip install mlflow boto3
RUN pip install petl
RUN pip install torch==1.6.0+cpu torchvision==0.7.0+cpu -f https://download.pytorch.org/whl/torch_stable.html
RUN conda config --set ssl_verify no
RUN conda update -n base conda

#oracle connect stub source at https://gist.github.com/kimus/10012910
USER root
RUN unzip instantclient-basic-linux*
RUN unzip instantclient-sdk-linux*
RUN ldconfig

USER $NB_UID

RUN pip install cx_oracle

ENV LD_LIBRARY_PATH=/home/jovyan/instantclient_21_1