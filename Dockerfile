FROM jupyter/all-spark-notebook
USER root
RUN apt-get update -y
RUN apt-get install -y build-essential unzip python-dev libaio-dev npm
RUN jupyter labextension install @jupyterlab/debugger
RUN conda install xeus-python -c conda-forge
RUN conda install -c anaconda pyodbc unixodbc
RUN pip install ntlm-auth
RUN pip install python-ntlm
RUN pip install torch==1.6.0+cpu torchvision==0.7.0+cpu -f https://download.pytorch.org/whl/torch_stable.html
