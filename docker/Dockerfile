FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
ENV VENV_PATH=/opt/venv
ENV PATH="$VENV_PATH/bin:$PATH"
ENV JUPYTER_PORT=8888
ENV MLFLOW_PORT=5000

RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv git curl build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv $VENV_PATH

RUN git clone https://github.com/Narwhal-TCC/data-science-notebooks.git /opt/lab && \
    pip install -r /opt/lab/requirements.txt

RUN git clone https://github.com/Narwhal-TCC/sonar-feature-extractor.git /opt/component && \
    pip install --upgrade pip build && \
    pip install /opt/component

RUN pip install jupyterlab mlflow

WORKDIR /opt/lab

RUN if [ -f pyproject.toml ]; then pip install .; fi

RUN mkdir -p /mnt/data

# Startup script to run both services
RUN echo '#!/bin/bash\n\
mlflow server \
  --host 0.0.0.0 \
  --port 5000 \
  --backend-store-uri sqlite:///opt/lab/dataset_matriz_1/example-mlflow/mlflow.db \
  --default-artifact-root /opt/lab/dataset_matriz_1/example-mlflow/mlflow-local/artifacts &\n\
exec jupyter lab \
  --ip=0.0.0.0 \
  --port=8888 \
  --no-browser \
  --allow-root \
  --notebook-dir=/opt/lab \
  --NotebookApp.token="" \
  --NotebookApp.password=""' > /opt/start.sh && chmod +x /opt/start.sh

EXPOSE 8888
EXPOSE 5000

CMD ["/opt/start.sh"]
